class Admin::PhotosController < Admin::AdminController
  before_filter :load_art
  before_filter :load_photo, :only => [:update, :destroy]

  def update
    flickr_username = params[:photo][:flickr_username]

    if params[:photo][:primary] == "1"
      @art.photos.update_all :primary => false
      @photo.primary = true
    end

    @photo.flickr_username = flickr_username
    @photo.save!
    redirect_to admin_art_path(@art), :notice => "Successfully updated photo's details."
  end

  def destroy
    @photo.destroy
    redirect_to admin_art_path(@art), :notice => "Photo deleted from ArtAround."
  end

  protected

  def load_art
    unless params[:art_id] and (@art = Art.where(:slug => params[:art_id]).first)
      head :not_found and return false
    end
  end
  
  def load_photo
    unless params[:id] and (@photo = @art.photos.where(:_id => BSON::ObjectId(params[:id])).first)
      head :not_found and return false
    end
  end

end