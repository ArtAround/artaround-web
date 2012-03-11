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

  def contact_form(name, email, text)
    @name = name
    @email = email
    @text = text
    mail :subject => "Contact form submission from #{@name} [#{@email}]"
  end

  def new_art_info(art, submission)
    @art = art
    @submission = submission
    mail :subject => "Art info correction submitted for #{@art.title}"
  end

  def art_flagged(art, text, source)
    @art = art
    @text = text
    @source = source
    mail :subject => "Art piece flagged (#{@source})"
  end
end