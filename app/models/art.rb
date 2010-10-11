class Art
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug
  
  references_many :comments
  embeds_many :submissions
  
  attr_protected :_id, :commissioned, :approved
  
  field :title
  slug :title
  
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
  
  scope :commissioned, :where => {:commissioned => true}
  scope :uncommissioned, :where => {:commissioned => false}
  scope :approved, :where => {:approved => true}
  scope :unapproved, :where => {:approved => false}
  
  scope :inbox, :where => {:approved => false}, :order_by => :created_at.desc
  scope :submitted, :order_by => :submitted_at.desc
  
  validates_presence_of :title
  validates_numericality_of :year, :allow_blank => true
  validates_numericality_of :ward, :allow_blank => true
  validate :contains_address, :on => :create
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
  
  # validation for either having latitude and longitude, or an address (address/city/state)
  def contains_address
    unless (latitude.present? and longitude.present?) or (address.present? and city.present? and state.present?)
      errors.add(:location, "not used") and return false
    end
  end
end