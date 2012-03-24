class Event
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug
  include Mongoid::MultiParameterAttributes

  has_many :arts

  slug :name

  field :name
  field :description
  field :website
  field :starts_at, :type => DateTime
  field :ends_at, :type => DateTime

  index :slug

  validates_presence_of :name
  validates_presence_of :starts_at
  validates_presence_of :ends_at
  validates_uniqueness_of :slug

  scope :current, lambda {{:where => {:ends_at.gte => Date.today}}}
end