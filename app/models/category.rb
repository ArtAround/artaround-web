class Category
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name

  has_and_belongs_to_many :arts
end