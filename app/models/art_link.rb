class ArtLink
  include Mongoid::Document
  field :art_id, :type => String
  field :title, :type => String
  field :link_url, :type => String
  field :link_title, :type => String

  belongs_to :art
end
