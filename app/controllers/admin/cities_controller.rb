class Admin::CitiesController < Admin::AdminController
	def index
		@cities = City.all
	end

  def new
    @city = City.new
  end

  def create
    @city = City.new params[:city]
    if @city.save
      redirect_to admin_cities_path, :notice => "Successfully Created City."
    else
      render :new
    end
  end

	def show
		@city = City.find(params[:id])
	end

	def update
		@city = City.find(params[:id])
		@city.name = params[:city][:name]
		@city.save
		redirect_to :back
	end

  def delete_city
    
    @city = City.find(params[:id])
    @city.destroy
    redirect_to admin_cities_path
  end

  def destroy
    @city = City.find(params[:id])
    @city.destroy
    redirect_to admin_cities_path
  end
end	