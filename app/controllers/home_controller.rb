class HomeController < ApplicationController
  
  def index
    @arts = Art.approved.all
    @categories = Art.all.distinct :category
    @neighborhoods = Art.all.distinct :neighborhood
  end
  
end