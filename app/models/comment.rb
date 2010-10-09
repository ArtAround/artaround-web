class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  
  referenced_in :art
  
  attr_protected :_id, :ip_address
  
  field :name
  field :email
  field :ip_address
  field :url
  field :text
  
  index :email
  index :ip_address
  
  scope :inbox, :order_by => :created_at.desc
  
  validates_presence_of :name
  validates_presence_of :email
  validates_presence_of :text
  validates_presence_of :art_id
  
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create
  validates_format_of :url, :with => URI.regexp(['http']), :on => :create, :allow_blank => true
end