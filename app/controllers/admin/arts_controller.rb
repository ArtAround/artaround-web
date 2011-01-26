class Admin::ArtsController < Admin::AdminController
  before_filter :load_art, :only => [:show, :update]
  
  def login
    # will only get here if they get through the admin_only filter
    redirect_to root_path, :notice => "You're logged in as an administrator."
  end
  
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
    # remove special case
    latitude = ["Click on Map", nil].include?(latitude) ? nil : latitude.to_f
    longitude = ["Click on Map", nil].include?(longitude) ? nil : longitude.to_f
    @art.location = [latitude, longitude]
    
    @art.attributes = params[:art]
    
    if @art.save
      redirect_to admin_art_path(@art), :notice => "Successfully updated art piece."
    else
      render :show
    end
  end
  
  protected
  
  def load_art
    unless params[:id] and (@art = Art.where(:slug => params[:id]).first)
      head :not_found and return false
    end
  end
  
end