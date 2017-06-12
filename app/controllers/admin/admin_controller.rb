class Admin::AdminController < ApplicationController
  before_action :admin_only
  
  protected
  
  def admin_only
    if session[:admin] == true
      return true 
    else
      authenticate_or_request_with_http_basic do |username, password|
        if username == credentials[:username] and password == credentials[:password]
          session[:admin] = true
          true
        else
          head 403 and return false
        end
      end
    end
  end
  
  def credentials
    @credentials ||= YAML.load_file "#{Rails.root}/config/admin.yml"
  end
end
