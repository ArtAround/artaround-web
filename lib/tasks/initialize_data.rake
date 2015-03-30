namespace :initialize do

  desc "Load in public art pieces from a CSV export of the old theartaround.us database"
  task :from_csv => :environment do
    Art.delete_all
    Comment.delete_all
  
    FasterCSV.foreach("data/initial/art.csv") do |row|
      art = Art.new
      
      art.category = row[0]
      art.title = row[1]
      art.artist = row[2]
      art.year = row[3]
      art.neighborhood = row[4]
      art.ward = row[5]
      art.location_description = row[6]
      art.location = [(row[7] || 0.0).to_f, (row[8] || 0.0).to_f]
      art.header = row[9]
      art.pitch = row[10]
      art.zoom = row[11]
      
      art.commissioned = row[12]
      art.approved = row[13]
      
      art.save!
    end
    
    puts "Loaded #{Art.count} art pieces into the database."
  end

  task :udate_pic_date => :environment do
    Photo.all.each do |p|
      p.pic_date = p.created_at
      p.save
    end  
  end  
end