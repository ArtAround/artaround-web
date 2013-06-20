class Admin::CommissionersController < Admin::AdminController
  before_filter :load_commissioner
  def show
  end

  def update
    @commissioner.attributes = params[:commissioner]
    if @commissioner.save
      redirect_to admin_commissioner_path(@commissioner), :notice => "Successfully updated commissioner."
    else
      render :show
    end
  end

  def destroy
    @commissioner.destroy
    redirect_to admin_path
  end

  def new

  end

  protected

  def load_commissioner
    unless params[:id] and (@commissioner = Commissioner.find(params[:id]))
      head :not_found and return false
    end
    @commissioners = Commissioner.all
  end
end
