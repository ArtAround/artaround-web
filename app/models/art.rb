class Art
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug
  # include Mongoid::MultiParameterAttributes

  has_many :comments
  has_many :art_link
  accepts_nested_attributes_for :art_link
  belongs_to :event, optional: true
  belongs_to :commissioned_by, :class_name => "Commissioner", :inverse_of => :arts, optional: true
  embeds_many :submissions
  has_many :photos, :dependent => :destroy
  has_many :tags, :dependent => :destroy
  # after_save :link_art_id

  # attr_protected :_id, :commissioned, :approved, :location, :slug

  before_save :ensure_well_formed_url
  before_save :set_photo_count

  # required field, used for slug
  field :title
  slug :title

  field :website

  # fields doubled on submissions
  field :tag, :type => Array
  field :tag_id, :type => Array
  field :category, :type => Array
  field :old_category
  field :artist, :type => Array
  field :new_artist
  field :year, :default => ""
  field :neighborhood
  field :ward, :default => ""
  field :location_description
  field :description
  field :approved

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
  field :photo_count, :type => Integer

  # index [[:location, Mongo::GEO2D]]
  index(location: '2d')
  # index :commissioned
  index(commissioned: 1)
  index(category: 1)
  index(approved: 1, slug: 1)
  # index [[:approved, Mongo::ASCENDING], [:slug, Mongo::ASCENDING]]
  index(approved: 1)
  index(total_visits: 1)
  index(web_visits: 1)
  index(api_visits: 1)

  scope :commissioned, -> { where({:commissioned => true}) }
  scope :uncommissioned, -> { where({:commissioned => false}) }
  scope :approved, -> { where(approved: true) }
  scope :unapproved, -> { where({:approved => false}) }
  scope :featured, -> { where({:featured => true}) }

  scope :inbox, -> { where({:approved => false}).order_by(:created_at.desc) }
  scope :submitted, -> { order_by(:submitted_at.desc) }

  scope :popular, -> { where({:ranking => {"$type" => 16}}).order_by(:ranking.asc) }
  scope :with_photos, -> { where(:photo_count.gt => 0) }

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

  def ensure_well_formed_url
    uri = URI(website) unless website.blank?
    unless website.blank? || uri.scheme == "http" || uri.scheme == "https"
      self.website = "http://" + website
    end
  end

  def link_art_id(link_title, link_url)
    ArtLink.create(
      :art_id => self.id,
      :link_title => link_title,
      :link_url => link_url
    )
  end

  def apply_submission submission
    self.tag                  = submission.tag.reject(&:blank?) if submission.tag.present?
    self.category             = submission.category.reject(&:blank?) if submission.category.present?
    self.artist               = submission.artist if submission.artist.present?
    self.year                 = submission.year
    self.description          = submission.description
    self.location_description = submission.location_description
    self.save!

    if submission.link?
      art_link          = ArtLink.new art_id: self.id
      art_link.title    = submission.link_title
      art_link.link_url = submission.link_url
      art_link.save!
    end

    submission.applied = true
    submission.save

    true
  end

  def set_photo_count
    self.photo_count = photos.count
  end

  def self.create_from_csv csv_row
    art = Art.new

    art.title = csv_row['Title']
    art.description = csv_row['Description']
    art.year = csv_row['Year']
    art.website = csv_row['Website']
    art.location = [csv_row['Latitude'].to_f, csv_row['Longitude'].to_f]
    art.location_description = csv_row['Location Description']

    art.artist = csv_row['Artist'].to_s.split(',').map do |a|
      Artist.where(name: a).first_or_create
      a
    end

    imported_tags = csv_row['Tags'].to_s.split(',').map do |tag_name|
      Tag.where(name: tag_name.strip).first_or_create
    end
    art.tag_id = imported_tags.map(&:id).map(&:to_s)
    art.tag = imported_tags.map(&:name)

    art.category = csv_row['Category'].split(',').map(&:strip)

    # Links are poorly formatted
    csv_row.select{|k,_| k.include? 'Link'}.each do |_, v|
      link = ArtLink.new_from_csv(v)
      art.art_link << link if link.present?
    end

    art.approved = true
    art.save
    art
  end
end
