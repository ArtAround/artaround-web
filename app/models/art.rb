class Art
  include Mongoid::Document
  include Mongoid::Timestamps
  
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
  
  # Used to orient street view
  field :yaw, :type => Float
  field :pitch, :type => Float
  field :zoom, :type => Float
  
  # flags
  field :commissioned, :type => Boolean
  field :approved, :type => Boolean
  
  # indexes
  index [[:location, Mongo::GEO2D]]
  index :neighborhood
  index :ward
  index :commissioned
  index :approved
  index :year
  index :category
  
  # scopes
  scope :commissioned, :where => {:commissioned => true}
  scope :uncommissioned, :where => {:commissioned => false}
  scope :approved, :where => {:approved => true}
  scope :unapproved, :where => {:approved => false}
  
  
  def latitude
    location[0]
  end
  
  def longitude
    location[1]
  end
end