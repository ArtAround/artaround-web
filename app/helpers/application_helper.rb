module ApplicationHelper
  
  def light_format(string)
    return "" unless string.present?
    string = simple_format h(string)
    auto_link string
  end

  def known(string)
    string.present? ? string : "Unknown"
  end

  def just_day(time)
    time.strftime("%b %Y")
  end

  def event_time_home(time)
    time.strftime("%B %Y")
  end

  def artist_type_for(art)
    if art.venue?
      "Curator"
    else
      "Artist"
    end
  end

  # valid sizes: 
  # ["Medium 800", "Small", "Small 320", "Medium", "Medium 640",
  # "Large Square", "Square", "Large", "Original", "Thumbnail"]
  def thumbnail_url(photo, size = "Large")
    size = size.to_s.capitalize
    return nil unless photo and photo.sizes[size]
    photo.sizes[size]['source']
  end

  def photo_url(photo)
    username = flickr_details[:account][:username]
    "http://www.flickr.com/photos/#{username}/#{photo.flickr_id}/"
  end

end