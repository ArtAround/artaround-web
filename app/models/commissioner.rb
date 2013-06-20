class Commissioner
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :arts, :autosave => true

  field :url, :type => String
  field :name, :type => String
  field :logo
end
