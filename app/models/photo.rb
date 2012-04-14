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

  validates_attachment_presence :image, :message => "Please include a photo."
  validates_attachment_size :image, :in => 0..2.megabytes, :message => "Photo must be less than 2 megabytes."
    # :content_type => { :content_type => "image/jpg" },
end