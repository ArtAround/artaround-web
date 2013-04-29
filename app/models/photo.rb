class Photo
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip

  belongs_to :art

  attr_protected :_id

  field :attribution_text, :type => String
  field :attribution_url, :type => String
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
  validates_attachment_size :image, :in => 0..6.megabytes, :message => "Photo must be less than 6 megabytes."
  validates_attachment_content_type :image, :content_type => ["image/jpeg", "image/gif", "image/jpg", "image/png"], :message => "Please include a JPG or PNG image for a photo."

  def attribution_text
    return self[:attribution_text] unless self[:attribution_text].blank?
    return attribution_url unless attribution_url.blank?
    return I18n.t :anonymous_user
  end
end
