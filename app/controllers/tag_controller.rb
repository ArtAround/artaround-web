class TagController < ApplicationController
	def show
    
    if params[:sort] == 'popular'
      sort = :total_visits
    else
      sort = :created_at
    end

      @arts = Art.approved.where(tag: params[:id]).desc(sort).page(params[:page]).per(25)
    respond_to do |format|
      format.html {render "arts/index"}
    end
	end
end
