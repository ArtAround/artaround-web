class Admin::CommentsController < Admin::AdminController
  before_filter :load_art
  before_filter :load_comment, :only => [:unapprove]
  
  def unapprove
    @comment.approved = false
    if @comment.save
      head 200
    else
      head 500
    end
  end
  
  protected
  
  def load_art
    unless params[:art_id] and (@art = Art.where(:slug => params[:art_id]).first)
      head :not_found and return false
    end
  end
  
  def load_comment
    unless params[:id] and (@comment = @art.comments.where(:_id => BSON::ObjectId(params[:id])).first)
      head :not_found and return false
    end
  end
  
end