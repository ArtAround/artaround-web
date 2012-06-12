class Admin::CommentsController < Admin::AdminController
  before_filter :load_art
  before_filter :load_comment, :only => [:unapprove, :approve]
  
  def unapprove
    @comment.approved = false
    @comment.save!
    head 200
  end

  def approve
    @comment.approved = true
    @comment.save!
    head 200
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