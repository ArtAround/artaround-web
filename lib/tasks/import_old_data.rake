namespace :old_data do

  desc "Load in public art pieces from a CSV export of the old theartaround.us database"
  task :load => :environment do
    i = 0
    FasterCSV.foreach("data/old/public_art.csv") do |row|
      art = Art.new
      
      art.category = row[1]
      art.title = row[2]
      art.artist = row[3]
      art.year = row[4] unless row[4] == 'Unkn'
      art.neighborhood = row[5]
      art.ward = row[6]
      art.location_description = row[7]
      art.location = [(row[8] || 0.0).to_f, (row[9] || 0.0).to_f]
      art.yaw = row[10]
      art.pitch = row[11]
      art.zoom = row[12]
      
      # skip panoramicid (row[13])
      
      art.commissioned = row[14]
      art.approved = row[15]
      
      art.save!
      i += 1
    end
    
    puts "Loaded #{i} art pieces into the database. Documents in the arts collection: #{Art.count}"
  end
end