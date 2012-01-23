class ArtsController < ApplicationController
  before_filter :load_art, :only => [:show, :comment, :submit, :add_photo]
  
  def new
    @art = Art.new
  end
  
  def create
    latitude = params[:art].delete 'latitude'
    longitude = params[:art].delete 'longitude'
    
    # remove special case
    latitude = ["Click on Map", nil].include?(latitude) ? nil : latitude.to_f
    longitude = ["Click on Map", nil].include?(longitude) ? nil : longitude.to_f
    
    @art = Art.new params[:art]
    
    @art.location = [latitude, longitude] if latitude and longitude
    
    @art.approved = true # auto-approve
    @art.commissioned = false
    
    unless params[:new_photo] and params[:new_photo].respond_to?(:path)
      flash.now[:alert] = "Please include a photo of this piece of art."
      @art.valid? # generate errors
      render :new
      return false
    end
    
    # save safely because the id must be used to tag the flickr photo
    if @art.safely.save
      # size check
      if File.size(params[:new_photo].path) > (1024*1024 * 2)
        @art.destroy
        flash.now[:alert] = "We ask that uploaded photos be less than 2MB in size. Please resize your photo so that it takes up less space and try again."
        render :new
      else
      
        AdminMailer.new_art(@art).deliver
        
        begin
          uploads = upload_photo @art, params[:new_photo].path
        rescue Fleakr::ApiError
          @art.destroy
          flash.now[:alert] = "There was a problem uploading your photo. If you don't mind, please try it again using the form on the righthand side."
          render :new
        else
          @art.flickr_ids ||= []
          if uploads.any?
            @art.flickr_ids << uploads.first.id
          end
          @art.save! # should not be a controversial operation
          
          redirect_to art_path(@art), :notice => "Thanks for contributing a new piece of art!"
        end
      end
    else
      render :new
    end
  end
  
  def submit
    @submission = @art.submissions.build params[:submission]
    
    if @submission.save
      @art.submitted_at = Time.now
      @art.save!
      
      AdminMailer.new_art_info @art, @submission
      
      redirect_to art_path(@art), :notice => "Thanks for helping us fill in the gaps! We moderate submissions, so your contribution should appear shortly."
    else
      @comment = Comment.new
      render :show
    end
  end
  
  def add_photo
    redirect_to(art_path(@art)) and return false unless params[:new_photo] and params[:new_photo].respond_to?(:path)
    
    # size check
    if File.size(params[:new_photo].path) > (1024*1024 * 2)
      redirect_to art_path(@art), :alert => "We ask that uploaded photos be less than 2MB in size. Please resize your photo so that it takes up less space and try again."
      return false
    end
    
    begin
      uploads = upload_photo @art, params[:new_photo].path
    rescue Fleakr::ApiError
      redirect_to art_path(@art), :alert => "There was a problem uploading your photo. If you don't mind, please try it again."
    else
      @art.flickr_ids ||= []
      if uploads.any?
        @art.flickr_ids << uploads.first.id
      end
      @art.save! # should not be a controversial operation
      
      
      AdminMailer.new_photo(@art).deliver
      
      redirect_to art_path(@art), :notice => "Thank you for contributing your photo! It should appear in the slideshow below."
    end
  end
  
  def show
    @comment = Comment.new
    @submission = @art.new_submission
  end
  
  def comment
    @comment = @art.comments.build params[:comment]
    @comment.ip_address = request.ip
    
    if @comment.save
      AdminMailer.new_comment(@art, params[:comment]['name'], params[:comment]['text']).deliver
      redirect_to @art, :notice => "Your comment has been posted below. Thanks for contributing!"
    else
      flash.now[:alert] = "Your comment couldn't be posted. Please look below and check for any missing fields or errors."
      @submission = @art.new_submission
      render :show
    end
  end

  def logger
    Rails.logger.info "#{params.inspect}"

    respond_to do |format|
      format.json { render :json => { :success => true } }
      format.html { render :text => "OK" }
    end
  end
  
  protected
  
  def load_art
    unless params[:id] and (@art = Art.where(:approved => true, :slug => params[:id]).first)
      head :not_found and return false
    end
  end
  
end
