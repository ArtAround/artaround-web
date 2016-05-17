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

  def domain_prefix
    host = "http://#{request.host}"
    if request.port != 80
      host << ":#{request.port}"
    end
    host
  end
 
end