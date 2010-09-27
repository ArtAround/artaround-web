class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'application'
  
  helper_method :recent_art
  def recent_art
    @recent_art ||= Art.descending(:created_at).limit(6)
  end
end
