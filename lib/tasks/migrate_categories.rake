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

  desc "Convert Flickr ids to attribution text/url"
  task :flickr => :environment do
    Photo.all.each do |photo|
      if photo.attribution_text.blank? & photo.respond_to?(:flickr_username)
        if photo.flickr_username.blank?
          photo.attribution_text = "anonymous user"
        else
          photo.attribution_text = photo.flickr_username
          photo.attribution_url = "http://www.flickr.com/#{photo.flickr_username}"
        end
        photo.save
      end
    end
  end


  desc "Convert old commisioned attribute to new commissioner model"
  task :commissioned => :environment do
   @commissioner = Commissioner.where({:name => 'DCArts'}).first
   if @commissioner.nil?
     @commissioner = Commissioner.create(:name => 'DCArts')
   end
   Art.all.each do |art|
     if art.commissioned
       @commissioner.arts << art
     end
   end
  end
end
