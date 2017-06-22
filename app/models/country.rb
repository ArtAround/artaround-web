class Country
  include Mongoid::Document
  validates :country_count, :numericality => {:only_integer => true}

  field :country_count, :type => Integer
end
