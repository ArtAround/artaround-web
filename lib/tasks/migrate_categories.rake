namespace :migrate do

  desc "Convert old category strings to new category array"
  task :categories => :environment do
    Art.all.each do |art|
      if art.category.class == String
        new_cat = []
        new_cat.push(art.category)
        art.category = new_cat
        valid_categories = ["Architecture", "Digital", "Drawing", "Installation",
                      "Interactive", "Gallery", "Graffiti", "Kinetic",
                      "Lighting installation", "Market", "Memorial",
                      "Mixed media", "Mosaic", "Mural", "Museum", "Painting",
                      "Paste", "Photograph", "Print", "Sculpture", "Statue",
                      "Stained glass", "Temporary", "Textile", "Plaster",
                      "Participatory", "Performance", "Projection", "Video",
                      "Other"]
        invalid = art.category - valid_categories
        art.old_category = invalid
        art.category = art.category - invalid
        art.save
      end
    end
  end
end
