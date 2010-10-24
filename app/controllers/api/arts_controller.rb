class Api::ArtsController < Api::ApiController
  
  def index
    render :json => json_for_list(Art.approved.all)
  end
  
end