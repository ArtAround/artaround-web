class Art
  include Mongoid::Document
  include Mongoid::Timestamps
  
  references_many :comments
  
  field :title
  field :category
  field :artist
  field :year
  field :description
  
  # DC location fields
  field :neighborhood
  field :ward
  
  # Location (array of lat/long)
  field :location, :type => Array
  # redundant for ease of validation, not indexed
  field :latitude, :type => Float
  field :longitude, :type => Float
  
  # Address (optional, will geocode to lat/long eventually)
  field :address
  field :city
  field :state
  field :zip
  
  # Used to orient street view
  field :yaw, :type => Float
  field :pitch, :type => Float
  field :zoom, :type => Float
  
  # flags
  field :commissioned, :type => Boolean
  field :approved, :type => Boolean
  
  index [[:location, Mongo::GEO2D]]
  index :neighborhood
  index :ward
  index :commissioned
  index :approved
  index :year
  index :category
  
  scope :commissioned, :where => {:commissioned => true}
  scope :uncommissioned, :where => {:commissioned => false}
  scope :approved, :where => {:approved => true}
  scope :unapproved, :where => {:approved => false}
  
  validates_presence_of :title
  validates_numericality_of :year, :allow_blank => true
  validates_numericality_of :latitude, :allow_nil => true
  validates_numericality_of :longitude, :allow_nil => true
  validate :contains_address, :on => :create
  
  before_create :store_location
  
  # should rename the field itself eventually
  def header
    yaw
  end
  
  def store_location
    self.location ||= []
    location[0] = latitude
    location[1] = longitude
  end
  
  # validation for either having latitude and longitude, or an address (address/city/state)
  def contains_address
    unless (latitude.present? and longitude.present?) or (address.present? and city.present? and state.present?)
      errors.add(:location, "not used") and return false
    end
  end
end