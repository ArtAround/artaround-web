class Api::ArtsController < Api::ApiController
  before_filter :load_art, :only => :show
  
  def index
    render :json => json_for_arts
  end
  
  def show
    render :json => json_for_art(@art)
  end
                    
  def neighborhoods_api
    render :json => neighborhoods.to_json
  end
  
  def categories_api
    render :json => categories.to_json
  end
  
  protected
  
  def load_art
    unless params[:id] and (@art = Art.where(:approved => true, :slug => params[:id]).only(art_fields).first)
      head :not_found and return false
    end
  end
                    
end