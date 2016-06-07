class Submission
  include Mongoid::Document
  include Mongoid::Timestamps
  
  embedded_in :art, :inverse_of => :submissions
  
  field :tag
  field :tag_id
  field :category
  field :artist
  field :year
  field :neighborhood
  field :ward
  field :location_description
  field :description
  
  validates_numericality_of :year, :allow_blank => true
  validates_numericality_of :ward, :allow_blank => true
end