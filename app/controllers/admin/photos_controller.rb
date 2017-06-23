class Admin::PhotosController < Admin::AdminController
  before_action :load_art
  before_action :load_photo, only: [:update, :destroy]

  def update
    attribution_text = params[:photo][:attribution_text]
    attribution_url = params[:photo][:attribution_url]

    if params[:photo][:primary] == '1'
      @art.photos.update_all primary: false
      @photo.primary = true
    end

    @photo.attribution_text = attribution_text
    @photo.attribution_url = attribution_url
    @photo.submitted_at = Time.new(params[:photo]['submitted_at(1i)'],
                                   params[:photo]['submitted_at(2i)'],
                                   params[:photo]['submitted_at(3i)'],
                                   params[:photo]['submitted_at(4i)'],
                                   params[:photo]['submitted_at(5i)'])
    @photo.save!
    redirect_to admin_art_path(@art),
                notice: 'Successfully updated photo\'s details.'
  end

  def destroy
    @photo.destroy
    redirect_to admin_art_path(@art), notice: 'Photo deleted from ArtAround.'
  end

  protected

  def photo_params
    params.require(:photo).permit(:attribution_text, :attribution_url,
                                  :primary)
  end

  def load_art
    @art = Art.find params[:art_id]
  end

  def load_photo
    @photo = @art.photos.find params[:id]
  end
end
