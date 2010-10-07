class ArtsController < ApplicationController
  before_filter :load_art, :only => [:show, :comment]
  
  def new
    @art = Art.new
  end
  
  def create
    @art = Art.new params[:art]
    
    # remove Click on Map special cases
    if @art.latitude == "Click on Map"
      @art.latitude = nil
    end
    
    if @art.longitude == "Click on Map"
      @art.longitude = nil
    end
    
    if @art.save
      redirect_to @art, :notice => "Thanks for letting us know about a new piece of art! We moderate submissions, so your entry should appear shortly."
    else
      render :new
    end
  end
  
  def show
    @comment = Comment.new
  end
  
  def comment
    @comment = @art.comments.build params[:comment]
    @comment.ip_address = request.ip
    
    if @comment.save
      redirect_to @art, :notice => "Your comment has been posted below. Thanks for contributing!"
    else
      render :show
    end
  end
  
  protected
  
  def load_art
    unless params[:id] and (@art = Art.find(params[:id]))
      head :not_found and return false
    end
  end
  
end