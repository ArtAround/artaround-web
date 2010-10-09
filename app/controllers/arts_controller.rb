class ArtsController < ApplicationController
  before_filter :load_art, :only => [:show, :comment, :submit]
  
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