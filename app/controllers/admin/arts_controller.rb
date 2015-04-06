class Admin::ArtsController < Admin::AdminController
  before_filter :load_art, :only => [:show, :update, :destroy]

  def index
    @arts = Art.desc(:created_at).all
    @events = Event.desc(:created_at).all
    @commissioners = Commissioner.desc(:created_at).all
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

    latitude = params[:art].delete 'latitude'
    longitude = params[:art].delete 'longitude'
    # remove special case
    latitude = ["Click on Map", nil].include?(latitude) ? nil : latitude.to_f
    longitude = ["Click on Map", nil].include?(longitude) ? nil : longitude.to_f
    @art.location = [latitude, longitude]

    @art.attributes = params[:art]
    @art.category.reject!(&:blank?)
    # @art.art_link.create( params[:art][:art_link_attributes]['0']) if params[:art][:art_link_attributes]['0'][:title].present?

    if @art.save
      redirect_to admin_art_path(@art), :notice => "Successfully updated art piece."
    else
      # always reset the slug so that URLs don't get messed up
      @art.slug = params[:id]
      render :show
    end
  end

  def manage_link
    # debugger
    if params[:link_url_id].present?
      art_link = ArtLink.find(params[:link_url_id])
      art_link.title = params[:title]
      art_link.link_url = params[:url]
      art_link.save
    else
      art_link = ArtLink.create(title: params[:title],link_url: params[:url],art_id: params[:art_id])
    end
    # redirect_to :back
    render :json => { :success => true }
  end

  def destroy_link
    ArtLink.find(params[:id]).delete
    redirect_to :back
    #render :json => { :success => true }
  end

  protected

  def load_art
    unless params[:id] and (@art = Art.where(:slug => params[:id]).first)
      head :not_found and return false
    end
    @events = Event.all
  end

end
