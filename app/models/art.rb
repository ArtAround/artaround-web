class Art
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug
  include Mongoid::MultiParameterAttributes
  
  has_many :comments
  belongs_to :event
  embeds_many :submissions
  has_many :photos

  
  attr_protected :_id, :commissioned, :approved, :location, :flickr_ids, :slug
  
  # required field, used for slug
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
  field :featured, :type => Boolean, :default => false

  # when an art piece was last flagged by a user
  field :flagged_at, :type => DateTime
  
  # last submitted at
  field :submitted_at, :type => DateTime

  # count of visits, very naive
  field :web_visits, :type => Integer
  field :api_visits, :type => Integer
  field :total_visits, :type => Integer # sum of the previous two, duplicated to make filtering easy
  field :ranking, :type => Integer
  
  index [[:location, Mongo::GEO2D]]
  index :commissioned
  index :category
  index [[:approved, Mongo::ASCENDING], [:slug, Mongo::ASCENDING]]
  index :approved
  index :slug
  index :total_visits
  index :web_visits
  index :api_visits
  
  scope :commissioned, :where => {:commissioned => true}
  scope :uncommissioned, :where => {:commissioned => false}
  scope :approved, :where => {:approved => true}
  scope :unapproved, :where => {:approved => false}
  scope :featured, :where => {:featured => true}
  
  scope :inbox, :where => {:approved => false}, :order_by => :created_at.desc
  scope :submitted, :order_by => :submitted_at.desc

  scope :popular, :where => {:ranking => {"$type" => 16}}, :order_by => :ranking.asc
  
  validates_presence_of :title
  validates_presence_of :category
  validates_numericality_of :year, :allow_blank => true
  validates_numericality_of :ward, :allow_blank => true
  validate :contains_location, :on => :create
  validates_uniqueness_of :slug
  
  def primary_photo
    photos.desc(:primary).first
  end

  def venue?
    ['Museum', 'Gallery', 'Market'].include? category
  end

  def latitude
    self.location ||= []
    location[0]
  end
  
  def longitude
    self.location ||= []
    location[1]
  end
  
  # new submissions should be blank, so that users are only entering the fields that they wish to correct
  def new_submission
    self.submissions.build(
      :category => nil,
      :artist => nil,
      :year => nil,
      :neighborhood => nil,
      :ward => nil,
      :location_description => nil,
      :description => nil
    )
  end

  def popular?
    ranking.present?
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