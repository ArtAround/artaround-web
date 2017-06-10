class Admin::ArtistsController < Admin::AdminController
  def index
    @artists = Artist.all
  end

  def new
    @artist = Artist.new
  end

  def create
    @artist = Artist.new artist_params
    if @artist.save
      redirect_to admin_artists_path, notice: 'Successfully Created Artist.'
    else
      render :new
    end
  end

  def show
    @artist = Artist.find(params[:id])
  end

  def update
    @artist = Artist.find(params[:id])
    @artist.name = params[:artist][:name]
    @artist.save
    redirect_to :back
  end

  def destroy
    @artist = Artist.find(params[:id])
    @artist.destroy
    redirect_to admin_artists_path
  end

  protected

  def artist_params
    params.require(:artist).permit(:name)
  end
end
