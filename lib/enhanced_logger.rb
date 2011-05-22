class EnhancedLogger < ActiveSupport::BufferedLogger

  class Railtie < Rails::Railtie
    initializer :initialize_enhanced_logger, :before => :initialize_logger  do
      app_config = Rails.application.config

      level = ActiveSupport::BufferedLogger.const_get(app_config.log_level.to_s.upcase)

      Rails.logger = config.logger = EnhancedLogger.new(app_config.paths.log.to_a.first, level)
    end
  end

  SEVERITIES = Severity.constants.inject([]) do |arr, c| 
    arr[Severity.const_get(c)] = c
    arr 
  end
 
  # Redefine the ActiveSupport::BufferedLogger#add
  def add(severity, message = nil, progname = nil, &block)
    return if @level > severity

    message = (message || (block && block.call) || progname).to_s
    message = "[#{Time.now.to_formatted_s(:db)}] #{SEVERITIES[severity]} #{parsed_message(message)}\n"
    buffer << message
    auto_flush

    message
  end

  private
    def parsed_message(message)
      m = message.strip

      msg = case m
            when ::String
              m
            when ::Exception
              "#{m.message} (#{m.class}: " << (m.backtrace || []).join(" | ")
            else
              m.inspect
            end

      msg.gsub(/\n/, '').lstrip
    end
end

