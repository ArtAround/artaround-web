class HomeController < ApplicationController
  
  def index
    @arts = Art.approved.all
  end
  
end