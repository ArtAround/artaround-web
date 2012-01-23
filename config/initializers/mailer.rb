@email = YAML.load_file "#{Rails.root}/config/email.yml"

ActionMailer::Base.smtp_settings = @email[:smtp]
ActionMailer::Base.default_url_options = { :host => @email[:hostname] }
ActionMailer::Base.default :from => @email[:from], :to => @email[:to]

logger = Logger.new "#{Rails.root}/log/mailer.log"
logger.level = Logger::INFO
ActionMailer::Base.logger = logger