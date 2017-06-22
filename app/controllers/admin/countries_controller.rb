class Admin::CountriesController < Admin::AdminController
  def index
    @countries = Country.all
  end

  def new
    @country = Country.new
  end

  def create
    @country = Country.new(params.require(:country).permit(:country_count))
    if @country.save
      redirect_to admin_countries_path, notice: 'Successfully Created Country.'
    else
      render :new
    end
  end

  def show
    @country = Country.find(params[:id])
  end

  def update
    @country = Country.find(params[:id])
    @country.country_count = params[:country][:country_count]
    @country.save
    redirect_to admin_countries_path
  end

  def destroy
    @country = Country.find(params[:id])
    @country.destroy
    redirect_to admin_countries_path
  end
end
