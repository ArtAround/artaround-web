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
  before_save :ensure_well_formed_url, :fill_in_blank_attribution_text

  has_mongoid_attached_file :image,
    :styles => {
      :thumbnail => "20x20",
      :small => "112x112",
      :big => "500x375"
    },
    :convert_options => { :all => '-auto-orient' },
    :path => ':rails_root/public/system/photos/:attachment/:id/:style.:extension',
    :url => '/system/photos/:attachment/:id/:style.:extension'

  validates_attachment_presence :image, :message => "Please include a photo."
  validates_attachment_size :image, :in => 0..6.megabytes, :message => "Photo must be less than 6 megabytes."
  validates_attachment_content_type :image, :content_type => ["image/jpeg", "image/gif", "image/jpg", "image/png"], :message => "Please include a JPG, GIF or PNG image for a photo."

  private

  def fill_in_blank_attribution_text
    if attribution_text.blank?
      if attribution_url.blank?
        self.attribution_text = I18n.t :anonymous_user
      else
        self.attribution_text = attribution_url
      end
    end
  end

  def ensure_well_formed_url
    self.attribution_url ||= ""
    uri = URI(self.attribution_url)
    unless self.attribution_url.blank? || uri.scheme == "http" || uri.scheme == "https"
      self.attribution_url = "http://" + attribution_url
    end
  end
end

