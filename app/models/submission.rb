class Submission
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :category
  field :artist
  field :year
  field :neighborhood
  field :ward
  field :location_description
  field :description
  
  embedded_in :art, :inverse_of => :submissions
  
  validates_numericality_of :year, :allow_blank => true
  validates_numericality_of :ward, :allow_blank => true
  
  scope :inbox, :order_by => :created_at.desc
end