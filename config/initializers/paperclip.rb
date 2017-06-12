require 'paperclip/media_type_spoof_detector'

if Rails.env.development?
  module Paperclip
    class MediaTypeSpoofDetector
      def spoofed?
        false
      end
    end
  end
end

