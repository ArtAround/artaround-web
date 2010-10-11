module ApplicationHelper
  
  def known(string)
    string.present? ? string : "Unknown"
  end
end
