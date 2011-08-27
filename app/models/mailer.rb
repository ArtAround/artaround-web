class Mailer
  
  attr_accessor :settings
  
  def initialize(settings)
    self.settings = settings
  end
  
  def send(subject, body, options = {})
    if settings[:pony][:to] and settings[:pony][:to].any?
      Pony.mail settings[:pony].merge(:body => body, :subject => subject).merge(options)
    end
  end
  
  def art_url(slug)
    "http://#{settings[:mailer][:domain]}/arts/#{slug}"
  end
  
  # specific mailers
  
  def send_contact_form(name, email, text)
    send "Contact form submission from #{name} [#{email}]", text
  end
  
  def send_new_art(title, slug)
    send "New art submission: #{title}", art_url(slug)
  end
  
  def send_new_comment(title, slug, commenter, comment_body)
    send "New comment by #{commenter} on #{title}", "#{art_url(slug)}\n\n#{comment_body}"
  end
  
  def send_new_photo(title, slug)
    send "New photo on #{title}", art_url(slug)
  end
    
end