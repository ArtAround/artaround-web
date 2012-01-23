class AdminMailer < ActionMailer::Base
  # default :from => "contact@theartaround.us"

  def new_comment(art, commenter, comment_body)
    @commenter = commenter
    @comment_body = comment_body
    @art = art
    mail :subject => "New comment by #{commenter} on #{@art.title}"
  end
end