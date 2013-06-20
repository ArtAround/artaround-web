class Commissioner
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip

  has_many :arts, :autosave => true

  field :url, :type => String
  field :name, :type => String
  has_mongoid_attached_file :logo,
    :styles => {
      :big => "500x375"
    },
    :path => ':rails_root/public/system/logos/:attachment/:id/:style.:extension',
    :url => '/system/logos/:attachment/:id/:style.:extension'
end
