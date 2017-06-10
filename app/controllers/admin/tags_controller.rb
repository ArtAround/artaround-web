class Admin::TagsController < Admin::AdminController
  def index
    @tags = Tag.all
  end

  def new
    @tag = Tag.new
  end

  def create
    @tag = Tag.new tag_params
    if @tag.save
      redirect_to admin_tags_path, notice: 'Successfully Created Tag.'
    else
      render :new
    end
  end

  def show
    @tag = Tag.find(params[:id])
  end

  def update
    @tag = Tag.find(params[:id])
    @tag.name = params[:tag][:name]
    @tag.save
    redirect_to :back
  end

  def destroy
    @tag = Tag.find(params[:id])
    @tag.destroy
    redirect_to admin_tags_path
  end

  protected

  def tag_params
    params.require(:tag).permit(:name)
  end
end
