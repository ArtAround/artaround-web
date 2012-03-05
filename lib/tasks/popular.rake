namespace :art do

  desc "Rank the top 20 art pieces, by number of views they've received"
  task :popular => :environment do
    number = ENV['number'] ? ENV['number'].to_i : 20

    puts "Clearing rankings of existing art..."
    Art.update_all :ranking => nil

    puts "Ranking the top #{number} pieces of art..."
    Art.desc(:total_visits).limit(number).each_with_index do |art, i|
      puts "[#{i+1}] #{art.slug}"
      art.ranking = i + 1
      art.save!
    end
  end

end