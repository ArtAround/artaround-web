@flickr = YAML.load_file "#{Rails.root}/config/flickr.yml"

Fleakr.api_key = @flickr[:account][:api_key]
Fleakr.shared_secret = @flickr[:account][:shared_secret]
Fleakr.auth_token = @flickr[:account][:auth_token]

logs = Logger.new "#{Rails.root}/log/fleakr.log"
logs.level = Logger::INFO
Fleakr.logger = logs