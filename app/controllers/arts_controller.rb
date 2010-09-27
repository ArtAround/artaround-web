class ArtsController < ApplicationController
  before_filter :load_art
  
  def show
  end
  
  protected
  
  def load_art
    unless params[:id] and (@art = Art.find(params[:id]))
      head :not_found and return false
    end
  end
  
end