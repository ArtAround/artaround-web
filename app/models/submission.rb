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
  field :link_title
  field :link_url
  field :applied, type: Boolean, default: false

  validates_numericality_of :year, :allow_blank => true
  validates_numericality_of :ward, :allow_blank => true

  def add_link_info params
    if params['link_title'] && params['link_url']
      self.link_title = params['link_title']
      self.link_url = params['link_url']
    end
  end

  def link?
    self.link_title.present? && self.link_url.present?
  end
end
