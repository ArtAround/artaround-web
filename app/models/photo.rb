class Photo
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :art

  attr_protected :_id

  field :flickr_id, :type => Integer
  field :flickr_username
  field :primary, :type => Boolean, :default => false
  field :sizes, :type => Hash, :default => {}

  validates_presence_of :flickr_id
end