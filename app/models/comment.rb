class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  
  referenced_in :art
  
  attr_protected :_id, :ip_address, :approved
  
  field :name
  field :email
  field :ip_address
  field :url
  field :text
  field :approved, :type => Boolean, :default => false
  
  index :email
  index :ip_address
  index :approved
  index [[:art_id, Mongo::ASCENDING], [:approved, Mongo::ASCENDING]]
  
  scope :inbox, :order_by => :created_at.desc
  scope :approved, :where => {:approved => true}
  scope :unapproved, :where => {:approved => false}
  
  validates_presence_of :name
  validates_presence_of :email
  validates_presence_of :text
  validates_presence_of :art_id
  
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create
end