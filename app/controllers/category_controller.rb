class CategoryController < ApplicationController
	def show
    
    valid_categories = ["Architecture", "Digital", "Drawing", "Gallery",
                          "Graffiti", "Installation", "Interactive",
                          "Kinetic", "Lighting installation", "Market",
                          "Memorial", "Mixed media", "Mosaic", "Mural",
                          "Museum", "Painting", "Performance", "Paste",
                          "Photograph", "Print", "Projection", "Sculpture",
                          "Statue", "Stained glass", "Temporary", "Textile",
                          "Video"]
    filter = params[:id]
    unless filter.nil?
      filter.capitalize!
    end
    unless valid_categories.include?(filter)
      filter = nil
    end

    if params[:sort] == 'popular'
      sort = :total_visits
    else
      sort = :created_at
    end
# debugger
    # if filter == nil
      # @arts = Art.approved.desc(sort).page(params[:page]).per(25)
    # else
      @arts = Art.approved.where(category: filter).desc(sort).page(params[:page]).per(25)
    # end
    respond_to do |format|
      format.html {render "arts/index"}
    end
  end
end
