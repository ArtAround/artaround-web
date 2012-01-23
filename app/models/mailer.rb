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
    
end