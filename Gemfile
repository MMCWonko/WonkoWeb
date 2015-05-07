source 'https://rubygems.org'

gem 'rails'
gem 'rabl'
gem 'slim'
gem 'slim-rails'
gem 'meta-tags'

# General assets
gem 'sass-rails'
gem 'coffee-rails'
gem 'uglifier'
gem 'analytical'

gem 'spring',        group: :development

# Styling/Theming (Bootstrap)
gem 'bootstrap-sass'
gem 'bootstrap_form'
gem 'bh'
gem 'bootstrap-select-rails'
gem 'bootstrap-switch-rails'
gem 'bootbox-rails'
gem 'breadcrumbs_on_rails'
gem 'abracadabra'
gem 'possessive'

# Javascript utils
gem 'jquery-rails'
gem 'turbolinks'
gem 'therubyracer',  platforms: :ruby

source 'https://rails-assets.org/' do
  gem 'rails-assets-timeago'
  gem 'rails-assets-URIjs'
end

# API and related
gem 'versionist'

# ORM and related
gem 'mongoid'
gem 'mongoid-slug'
gem 'mongoid-history'
gem 'bson_ext'
gem 'kaminari'
gem 'bcrypt'
gem 'delayed_job_mongoid'
gem 'dj_mon', github: 'akshayrawat/dj_mon'
gem 'public_activity', github: 'pokonski/public_activity'

# User management
gem 'devise'
gem 'devise_uid'
gem 'devise-async'
gem 'pundit'
gem 'devise-bootstrap-views'
gem 'gravatar-ultimate'
# TODO: Replace devise by omniauth/omniauth-identity/shield/warden?

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'bullet'
  gem 'meta_request'
  gem 'quiet_assets'
  gem 'rack-dev-mark'
  gem 'rack-prettify', github: 'logicaltext/rack-prettify'
end

group :development, :test do
  # Guard related
  gem 'guard'
  gem 'rb-inotify'
  gem 'guard-rspec'
  gem 'guard-bundler'
  gem 'guard-brakeman'
  gem 'guard-rubocop'
  gem 'reek'
  gem 'flay'
  gem 'flog'

  # Pry and related
  gem 'pry'
  gem 'pry-nav'
  gem 'pry-stack_explorer'
  gem 'pry-rails'
  gem 'pry-rescue'

  # Testing helpers
  gem 'database_cleaner'
  gem 'fabrication'
  gem 'faker'

  # RSpec related
  gem 'spring-commands-rspec'
  gem 'rspec-rails'
  gem 'mongoid-rspec'
  gem 'rubocop-rspec'
  gem 'capybara'
end

group :production do
  gem 'rails_12factor'
  gem 'puma'
  gem 'airbrake'
  gem 'piwik_analytics'
end

gem 'codeclimate-test-reporter', group: :test, require: nil

# activeadmin?
