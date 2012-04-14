class Photo
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip

  belongs_to :art

  attr_protected :_id

  field :flickr_id, :type => Integer
  field :flickr_username
  field :primary, :type => Boolean, :default => false
  field :sizes, :type => Hash, :default => {}

  has_mongoid_attached_file :image, 
    :styles => {
      :thumbnail => "20x20", 
      :small => "112x112",
      :big => "500x375"
    }, 
    :path => ':rails_root/public/system/photos/:attachment/:id/:style.:extension',
    :url => '/system/photos/:attachment/:id/:style.:extension'

end