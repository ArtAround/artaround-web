class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  
  referenced_in :art
  
  field :name, :type => String
  field :email, :type => String
  field :ip_address, :type => String
  field :url, :type => String
  field :text, :type => String
  
  index :email
  index :ip_address
  
  validates_presence_of :name
  validates_presence_of :email
  validates_presence_of :text
  validates_presence_of :art_id
  
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create
  validates_format_of :url, :with => URI.regexp(['http']), :on => :create, :allow_blank => true
end