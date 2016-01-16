class Tag
  include Mongoid::Document
  belongs_to :art
  field :name, :type => String
end
