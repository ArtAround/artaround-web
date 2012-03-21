class Admin::ArtsController < Admin::AdminController
  before_filter :load_art, :only => [:show, :update, :destroy]
  
  def index
    @arts = Art.desc(:created_at).all
    @events = Event.desc(:created_at).all
  end
  
  def show
  end

  def destroy
    @art.destroy
    redirect_to admin_path
  end
  
  def update
    # some attributes are protected from mass assignment, pluck them out
    @art.commissioned = params[:art].delete 'commissioned'
    @art.approved = params[:art].delete 'approved'
    
    # special case - slug
    # can't do a validates_presence_of for weird reasons, so validate here
    slug = params[:art].delete 'slug'
    if slug.present?
      @art.slug = slug
    end
    
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
      # always reset the slug so that URLs don't get messed up
      @art.slug = params[:id]
      render :show
    end
  end
  
  protected
  
  def load_art
    unless params[:id] and (@art = Art.where(:slug => params[:id]).first)
      head :not_found and return false
    end
    @events = Event.all
  end
  
end