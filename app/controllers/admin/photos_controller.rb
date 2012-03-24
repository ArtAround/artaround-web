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
    @art.flickr_ids = @art.reload.photos.map &:flickr_id
    @art.save!
    begin
      flickr.photos.delete :photo_id => @photo.flickr_id
    rescue FlickRaw::FailedResponse
      redirect_to admin_art_path(@art), :notice => "Photo de-associated from art piece, but WAS NOT removed from Flickr. Remove it manually, or verify that it has already been removed."
    else
      redirect_to admin_art_path(@art), :notice => "Photo deleted from ArtAround and Flickr."
    end
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