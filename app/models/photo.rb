class Photo
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip

  belongs_to :art, optional: true

  # attr_protected :_id

  field :attribution_text, :type => String
  field :attribution_url, :type => String
  field :primary, :type => Boolean, :default => false
  field :submitted_at, :type => DateTime
  field :sizes, :type => Hash, :default => {}
  before_save :ensure_well_formed_url
  before_create :set_submitted_at

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
  # validates_attachment_content_type :image, :content_type => ["application/octet-stream", "image/jpeg", "image/gif", "image/jpg", "image/png"], :message => "Please include a JPG, GIF or PNG image for a photo."
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

  def attribution_text_for_display
    return attribution_text unless attribution_text.blank?
    return attribution_url unless attribution_url.blank?
    return I18n.t :anonymous_user
  end

  private

  def set_submitted_at
    self.submitted_at = DateTime.now
  end

  def ensure_well_formed_url
    self.attribution_url ||= ""
    uri = URI(self.attribution_url)
    unless self.attribution_url.blank? || uri.scheme == "http" || uri.scheme == "https"
      self.attribution_url = "http://" + attribution_url
    end
  end
end

