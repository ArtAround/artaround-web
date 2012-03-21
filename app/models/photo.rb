class Photo
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :art

  attr_protected :_id

  field :flickr_id, :type => Integer
  field :flickr_username

  validates_presence_of :flickr_id
end