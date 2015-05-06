Rails.application.configure do
  config.middleware.use Rack::Prettify
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  config.after_initialize do
    Bullet.enable = true
    Bullet.alert = true
    Bullet.bullet_logger = true
    Bullet.console = true
    Bullet.rails_logger = true
    Bullet.add_footer = true
  end

  # Enable rack-dev-mark
  config.rack_dev_mark.enable = true
  #
  # Customize the env string (default Rails.env)
  # config.rack_dev_mark.env = 'foo'
  #
  # Customize themes if you want to do so
  # config.rack_dev_mark.theme = [:title, :github_fork_ribbon]
  #
  # Customize inserted place of the middleware if necessary.
  # You can use either `insert_before` or `insert_after`
  # config.rack_dev_mark.insert_before SomeOtherMiddleware
  # config.rack_dev_mark.insert_after SomeOtherMiddleware
end

BetterErrors::Middleware.allow_ip! ENV['TRUSTED_IP'] if ENV['TRUSTED_IP']
