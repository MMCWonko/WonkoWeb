if Rails.env.production?
  Airbrake.configure do |config|
    config.host = ENV['AIRBRAKE_HOST'] || 'localhost'
    config.port = ENV['AIRBRAKE_PORT'] || '1112'
    config.api_key = Rails.application.secrets['errbit_key']

    config.user_attributes = [:id, :username]
    config.user_information = '<p>For support, please mention the error id <strong>{{ error_id }}</strong>'

    Rails.logger.error "Using Airbrake #{config.host}:#{config.port}, key '#{config.api_key}'" if Rails && Rails.logger
  end
end
