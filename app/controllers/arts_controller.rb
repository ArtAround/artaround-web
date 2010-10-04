class ArtsController < ApplicationController
  before_filter :load_art, :only => [:show, :comment]
  
  def show
    @comment = Comment.new
  end
  
  def new
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