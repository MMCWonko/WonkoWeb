if Rails.env.production?
  Airbrake.configure do |config|
    config.host = ENV['AIRBRAKE_HOST'] || 'localhost'
    config.port = ENV['AIRBRAKE_PORT'] || '5001'
    config.api_key = ENV['AIRBRAKE_KEY']

    Rails.logger.error "Using Airbrake #{config.host}:#{config.port}, key '#{config.api_key}'"
  end
end
