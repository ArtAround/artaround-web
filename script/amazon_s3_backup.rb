require 'aws/s3'

def upload_photo(directory)
  photo_files = Dir.glob("#{directory}/*")
  photo_files.each do |file|
    AWS::S3::S3Object.store(file, open(file), 'ArtAroundPhotoBackups')
  end
end

AWS::S3::Base.establish_connection!(
    :access_key_id     => "",#REDACTED
    :secret_access_key => "" #REDACTED
)

file_to_transfer = ARGV.first
AWS::S3::S3Object.store(file_to_transfer, open(file_to_transfer), 'ArtAroundDatabaseBackups')

begin
  last_uploaded = File.read("last_uploaded_photo.txt")
  last_mtime = Time.new(2002, 10, 31, 2, 2, 2, "+02:00")
  last_success = last_uploaded
  if File.exists?(last_uploaded)
    last_mtime = File.mtime(last_uploaded)
  end

  start_dir = Dir.pwd
  Dir.chdir "/home/dotthei/webapps/artaround/artaround/shared/system/photos/images"

  photos = Dir.glob("*")
  date_ordered_photos = photos.sort_by { |file| File.mtime(file) }
  date_ordered_photos.each do |photo_directory|
    puts photo_directory
    if File.mtime(photo_directory) >= last_mtime
      upload_photo(photo_directory)
      last_success = photo_directory
    end
  end
rescue Exception => e
  puts "Error uploading photos to AWS! #{e.message}"
ensure
  Dir.chdir start_dir
  File.open("last_uploaded_photo.txt", 'w') { |file| file.write(last_success) }
end
