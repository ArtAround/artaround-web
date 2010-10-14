class Mailer
  
  def initialize(settings)
    self.settings = settings
  end
  
  def settings
    @settings
  end
  
  def settings=(settings)
    @settings = settings
  end
  
  def send(subject, body)
    Pony.mail settings.merge(:body => body, :subject => subject)
  end
  
  
  # specific mailers
  
  def send_contact_form(name, email, text)
    send "Contact form submission from #{name} [#{email}]", text
  end
end