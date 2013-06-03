namespace :migrate do

  desc "Convert old category strings to new category array"
  task :categories => :environment do
    Art.all.each do |art|
      if art.category.class == String
        new_cat = []
        new_cat.push(art.category.capitalize)
        art.category = new_cat
        valid_categories = ["Architecture", "Digital", "Drawing", "Gallery",
                            "Graffiti", "Installation", "Interactive",
                            "Kinetic", "Lighting installation", "Market",
                            "Memorial", "Mixed media", "Mosaic", "Mural",
                            "Museum", "Painting", "Performance", "Paste",
                            "Photograph", "Print", "Projection", "Sculpture",
                            "Statue", "Stained glass", "Temporary", "Textile",
                            "Video"]
        invalid = art.category - valid_categories
        art.old_category = invalid
        art.category = art.category - invalid
        art.save
      end
    end
  end
end
