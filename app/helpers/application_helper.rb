module ApplicationHelper
  
  def known(string)
    string.present? ? string : "Unknown"
  end

  def just_day(time)
    time.strftime("%b %Y")
  end

end