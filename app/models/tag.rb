class Tag
  include Mongoid::Document
  belongs_to :art, optional: true

  field :name, type: String
end
