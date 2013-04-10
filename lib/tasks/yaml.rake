namespace :data do

  desc "Export database to YAML."
  task :to_yaml => :environment do
    dump_fixture "arts"
    dump_fixture "comments"
  end
  
  desc "Wipe database and import from YAML."
  task :from_yaml => :environment do
    Art.delete_all
    Comment.delete_all
    restore_fixture "arts"
    restore_fixture "comments"
  end
  
end

def restore_fixture(name)
  model = name.singularize.camelize.constantize
  
  YAML::load_file("data/yaml/#{name}.yml").each do |row|
    record = model.new
    row.keys.each do |field|
      record[field] = row[field] if row[field]
    end
    record.save
  end
  
  puts "Loaded #{name} collection from fixtures"
end

def dump_fixture(name)
  collection = Mongoid.database.collection name
  records = []
  
  collection.find({}).each do |record|
    records << record_to_hash(record)
  end
  
  FileUtils.mkdir_p "fixtures"
  File.open("data/yaml/#{name}.yml", "w") do |file|
    YAML.dump records, file
  end
  
  puts "Dumped #{name} collection to fixtures"
end

def record_to_hash(record)
  return record unless record.class == BSON::OrderedHash
  
  new_record = {}
  
  record.delete '_id'
  record.each do |key, value|
  
    if value.class == Array
      new_record[key] = value.map {|object| record_to_hash object}
    else
      new_record[key] = record_to_hash value
    end
    
  end
  
  new_record
end
