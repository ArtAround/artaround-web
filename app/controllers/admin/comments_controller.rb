class Admin::CommentsController < Admin::AdminController
  before_action :load_art
  before_action :load_comment, only: [:unapprove, :approve]

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

  def delete
    @comment = Comment.find(params[:id])
    @comment.destroy
    head 200
  end

  protected

  def load_art
    @art = Art.find(params[:art_id])
  end

  def load_comment
    @comment = @art.comments.find(params[:id])
  end
end
