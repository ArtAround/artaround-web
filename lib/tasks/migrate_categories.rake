namespace :migrate do

  desc "Convert old category strings to new category array"
  task :categories => :environment do
    Art.all.each do |art|
      if art.category.class == String
        new_cat = []
        new_cat.push(art.category)
        art.category = new_cat
        art.save
      end
    end
  end
end
