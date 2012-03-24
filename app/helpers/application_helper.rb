module ApplicationHelper
  
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

end