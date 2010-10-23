class Admin::ArtsController < ApplicationController
  before_filter :admin_only
  before_filter :load_art, :only => [:show, :update]
  
  def show
  end
  
  def update
    # some attributes are protected from mass assignment, pluck them out
    @art.commissioned = params[:art].delete 'commissioned'
    @art.approved = params[:art].delete 'approved'
    
    # filter out any blank flickr_ids
    #@art.flickr_ids = params[:art].delete('flickr_ids').select {|id| id.present?}
    
    latitude = params[:art].delete 'latitude'
    longitude = params[:art].delete 'longitude'
    @art.location = [latitude, longitude] if latitude and longitude
    
    @art.attributes = params[:art]
    
    if @art.save
      redirect_to admin_art_path(@art), :notice => "Successfully updated art piece."
    else
      render :show
    end
  end
  
  protected
  
  def admin_only
    return true if session[:admin] == true
    
    authenticate_or_request_with_http_basic do |username, password|
      if username == credentials[:username] and password == credentials[:password]
        session[:admin] = true
        true
      else
        redirect_to root_path and return false
      end
    end
  end
  
  def load_art
    unless params[:id] and (@art = Art.where(:slug => params[:id]).first)
      head :not_found and return false
    end
  end
  
  def credentials
    @credentials ||= YAML.load_file "#{Rails.root}/config/admin.yml"
  end
  
end