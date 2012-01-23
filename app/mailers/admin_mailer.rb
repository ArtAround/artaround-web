class AdminMailer < ActionMailer::Base

  def new_comment(art, commenter, comment_body)
    @commenter = commenter
    @comment_body = comment_body
    @art = art
    mail :subject => "New comment by #{commenter} on #{@art.title}"
  end

  def new_art(art)
    @art = art
    mail :subject => "New art submission: #{@art.title}"
  end

  def new_photo(art)
    @art = art
    mail :subject => "New photo on #{@art.title}"
  end
end