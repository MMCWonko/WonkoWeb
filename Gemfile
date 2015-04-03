source 'https://rubygems.org'

gem 'rails'
gem 'rabl'
gem 'slim'
gem 'slim-rails'

# General assets
gem 'sass-rails'
gem 'coffee-rails'
gem 'uglifier'

gem 'spring',        group: :development

# Styling/Theming (Bootstrap)
gem 'bootstrap-sass'
gem 'bootstrap_form'
gem 'bh'
gem 'bootstrap-select-rails'
gem 'bootstrap-switch-rails'
gem 'bootbox-rails'
gem 'breadcrumbs_on_rails'

# Javascript utils
gem 'jquery-rails'
gem 'uri-js-rails'
gem 'turbolinks'
gem 'therubyracer',  platforms: :ruby

# ORM and related
gem 'mongoid'
gem 'mongoid-slug'
gem 'bson_ext'
gem 'kaminari'
gem 'bcrypt'

# User management
gem 'devise'
gem 'devise_uid'
gem 'pundit'
gem 'devise-bootstrap-views'

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'pry'
  gem 'pry-nav'
  gem 'pry-stack_explorer'
  gem 'bullet'
  gem 'meta_request'
  gem 'quiet_assets'
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

  # Testing helpers
  gem 'database_cleaner'
  gem 'fabrication'
  gem 'faker'

  # RSpec related
  gem 'spring-commands-rspec'
  gem 'rspec-rails'
  gem 'mongoid-rspec'
  gem 'rubocop-rspec'
end

group :production do
  gem 'rails_12factor'
  gem 'puma'
  gem 'airbrake'
  gem 'piwik_analytics'
end

gem 'codeclimate-test-reporter', group: :test, require: nil

# activeadmin?
