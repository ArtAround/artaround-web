class Admin::PhotosController < Admin::AdminController
  before_filter :load_art
  before_filter :load_photo, only: [:update, :destroy]

  def update
    attribution_text = params[:photo][:attribution_text]
    attribution_url = params[:photo][:attribution_url]

    if params[:photo][:primary] == '1'
      @art.photos.update_all primary: false
      @photo.primary = true
    end

    @photo.attribution_text = attribution_text
    @photo.attribution_url = attribution_url
    @photo.save!
    redirect_to admin_art_path(@art),
                notice: 'Successfully updated photo\'s details.'
  end

  def destroy
    @photo.destroy
    redirect_to admin_art_path(@art), notice: 'Photo deleted from ArtAround.'
  end

  protected

  def load_art
    @art = Art.find params[:art_id]
  end

  def load_photo
    @photo = @art.photos.find params[:id]
  end
end
