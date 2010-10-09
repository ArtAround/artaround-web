class Photo
  include Mongoid::Document
  include Mongoid::Timestamps
  
  attr_protected :_id
  
end