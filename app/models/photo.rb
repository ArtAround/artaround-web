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
  validates_attachment_size :image, :in => 0..4.megabytes, :message => "Photo must be less than 4 megabytes."
  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/png"], :message => "Please include a JPG or PNG image for a photo."

  # temporary, for legacy importing, useful for a while
  require 'open-uri'
  def import_from_flickr
    if self.sizes and self.sizes['Original']
      url = self.sizes['Original']['source']
      self.image = open(url)
      begin
        self.save!
        puts "[#{art.slug}] Processed"
        return true
      rescue
        puts "[#{art.slug}] ERROR: #{self.errors.messages.values.join ", "}"
      end
    else
      puts "[#{art.slug}] No flickr source URL!"
    end
    false
  end

end