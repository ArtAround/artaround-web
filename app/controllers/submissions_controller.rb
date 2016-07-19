class SubmissionsController < ApplicationController

  def approve
    redirect_to art
  end
  

  def art
    Art.find_by_slug(params[:art_id])
  end

end
