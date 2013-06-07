class Art
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug
  include Mongoid::MultiParameterAttributes

  has_many :comments
  belongs_to :event
  embeds_many :submissions
  has_many :photos, :dependent => :destroy


  attr_protected :_id, :commissioned, :approved, :location, :slug

  # required field, used for slug
  field :title
  slug :title

  field :website

  # fields doubled on submissions
  field :category, :type => Array
  field :old_category
  field :artist
  field :year, :default => ""
  field :neighborhood
  field :ward, :default => ""
  field :location_description
  field :description

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
  field :commissioned, :type => Boolean, :default => false
  field :approved, :type => Boolean, :default => false
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
  validate :contains_valid_categories
  validates_numericality_of :year, :allow_blank => true
  validate :contains_location, :on => :create
  validates_uniqueness_of :slug

  def url
    "/arts/#{slug}"
  end

  def timeline_year
    if year.present? and year.to_i > 0
      year.to_i
    else
      Time.now.year
    end
  end

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
        result = Geocoder.search full_address
        if !result.empty?
          self.location = [result.first.geometry['location']['lat'],
            result.first.geometry['location']['lng']]
        else
          errors.add(:geocode, "not used") and return false
        end
      else
        errors.add(:location, "not used") and return false
      end
    end
  end

  def contains_valid_categories
    if category.nil?
      return true
    else
      valid_categories = ["Architecture", "Digital", "Drawing", "Gallery",
                          "Graffiti", "Installation", "Interactive",
                          "Kinetic", "Lighting installation", "Market",
                          "Memorial", "Mixed media", "Mosaic", "Mural",
                          "Museum", "Painting", "Performance", "Paste",
                          "Photograph", "Print", "Projection", "Sculpture",
                          "Statue", "Stained glass", "Temporary", "Textile",
                          "Video"]
      invalid = category - valid_categories
      if invalid.length != 0
        errors.add(:category, "invalid categories") and return false
      end
    end
  end
end
