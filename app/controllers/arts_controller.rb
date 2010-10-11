class ArtsController < ApplicationController
  before_filter :load_art, :only => [:show, :comment, :submit, :add_photo]
  
  def new
    @art = Art.new
  end
  
  def create
    latitude = params[:art].delete 'latitude'
    longitude = params[:art].delete 'longitude'
    
    # remove special case
    latitude = nil if latitude == "Click on Map"
    longitude = nil if longitude == "Click on Map"
    
    params[:art][:location] = [latitude, longitude]
    
    @art = Art.new params[:art]
    @art.approved = false
    @art.commissioned = false
    
    if @art.save
      redirect_to new_art_path, :notice => "Thanks for letting us know about a new piece of art! We moderate submissions, so your contribution should appear shortly."
    else
      render :new
    end
  end
  
  def submit
    @submission = @art.submissions.build params[:submission]
    
    if @submission.save
      @art.submitted_at = Time.now
      @art.save!
      
      redirect_to art_path(@art), :notice => "Thanks for helping us fill in the gaps! We moderate submissions, so your contribution should appear shortly."
    else
      @comment = Comment.new
      render :show
    end
  end
  
  def add_photo
    head 404 and return false unless params[:new_photo] and params[:new_photo].respond_to?(:path)
    
    # size check
    if File.size(params[:new_photo].path) > (1024*1024 * 4)
      redirect_to art_path(@art), :alert => "We ask that uploaded photos be less than 4MB in size. Please resize your photo so that it takes up less space and try again."
      return false
    end
    
    begin
      uploads = Fleakr.upload params[:new_photo].path, {
        :title => @art.title,
        :tags => ["art-id-#{@art.id}", flickr[:metadata][:tag]],
        :viewable_by => flickr[:metadata][:viewable_by],
        :level => flickr[:metadata][:level],
        :type => flickr[:metadata][:type]
      }
    rescue Fleakr::ApiError
      redirect_to art_path(@art), :alert => "There was a problem uploading your photo. If you don't mind, please try it again."
    else
      @art.flickr_ids ||= []
      @art.flickr_ids << uploads.first.id
      @art.save! # should not be a controversial operation
      
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
      redirect_to @art, :notice => "Your comment has been posted below. Thanks for contributing!"
    else
      @art.new_submission
      render :show
    end
  end
  
  protected
  
  def load_art
    unless params[:id] and (@art = Art.first(:conditions => {:id => BSON::ObjectId(params[:id]), :approved => true}))
      head :not_found and return false
    end
  end
  
end