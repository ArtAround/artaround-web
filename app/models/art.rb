class Art
  include Mongoid::Document
  include Mongoid::Timestamps
  
  references_many :comments
  
  field :title
  field :category
  field :artist
  field :year
  field :location_description
  field :description
  
  # DC location fields
  field :neighborhood
  field :ward
  
  # Location (array of lat/long)
  field :location, :type => Array
  
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
  
  scope :inbox, :where => {:approved => false}, :order_by => :created_at.desc
  
  validates_presence_of :title
  validates_numericality_of :year, :allow_blank => true
  validates_numericality_of :ward, :allow_blank => true
  validate :contains_address, :on => :create
  
  
  def latitude
    self.location ||= []
    location[0]
  end
  
  def longitude
    self.location ||= []
    location[1]
  end
  
  # validation for either having latitude and longitude, or an address (address/city/state)
  def contains_address
    unless (latitude.present? and longitude.present?) or (address.present? and city.present? and state.present?)
      errors.add(:location, "not used") and return false
    end
  end
end