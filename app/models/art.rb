class Art
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug
  
  references_many :comments
  embeds_many :submissions
  
  attr_protected :_id, :commissioned, :approved, :location, :flickr_ids
  
  field :title
  slug :title
  
  field :website
  
  # fields doubled on submissions
  field :category
  field :artist
  field :year
  field :neighborhood
  field :ward
  field :location_description
  field :description
  
  # Location (array of lat/long)
  field :location, :type => Array
  
  # pointers to photos on Flickr
  field :flickr_ids, :type => Array
  
  # Address (optional, will geocode to lat/long eventually)
  field :address
  field :city
  field :state
  field :zip
  
  # Used to orient street view
  field :header, :type => Float
  field :pitch, :type => Float
  field :zoom, :type => Float
  
  # flags
  field :commissioned, :type => Boolean
  field :approved, :type => Boolean
  
  field :submitted_at, :type => DateTime
  
  index [[:location, Mongo::GEO2D]]
  index :neighborhood
  index :ward
  index :commissioned
  index :approved
  index :year
  index :category
  
  index [[:approved, Mongo::ASCENDING], [:slug, Mongo::ASCENDING]]
  
  scope :commissioned, :where => {:commissioned => true}
  scope :uncommissioned, :where => {:commissioned => false}
  scope :approved, :where => {:approved => true}
  scope :unapproved, :where => {:approved => false}
  
  scope :inbox, :where => {:approved => false}, :order_by => :created_at.desc
  scope :submitted, :order_by => :submitted_at.desc
  
  validates_presence_of :title
  validates_presence_of :category
  validates_numericality_of :year, :allow_blank => true
  validates_numericality_of :ward, :allow_blank => true
  validate :contains_location, :on => :create
  validates_uniqueness_of :slug
  
  
  def latitude
    self.location ||= []
    location[0]
  end
  
  def longitude
    self.location ||= []
    location[1]
  end
  
  def new_submission
    self.submissions.build(
      :category => category,
      :artist => artist,
      :year => year,
      :neighborhood => neighborhood,
      :ward => ward,
      :location_description => location_description,
      :description => description
    )
  end
  
  def contains_location
    if !latitude.present? and !longitude.present?
      if address.present? and state.present? and city.present?
        full_address = "#{address}, #{city}, #{state}"
        full_address += " #{zip}" if zip.present?
        
        result = Geokit::Geocoders::GoogleGeocoder.geocode full_address
        if result.success?
          self.location = [result.lat, result.lng]
        else
          errors.add(:geocode, "not used") and return false
        end
      else
        errors.add(:location, "not used") and return false
      end
    end
  end
end