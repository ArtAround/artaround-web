class ArtLink
  include Mongoid::Document
  field :art_id, :type => String
  field :title, :type => String
  field :link_url, :type => String
  field :link_title, :type => String

  belongs_to :art

  def self.new_from_csv(csv_data)
    title, url = csv_data.try(:split, ';')
    if title.present? && url.present?
      ArtLink.new title: title, link_title: title, link_url: url
    end
  end

  def safe_url
    return link_url if link_url.include? 'http'

    "http://#{link_url}"
  end
end
