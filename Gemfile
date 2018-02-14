# frozen_string_literal: true

source 'https://rubygems.org'

ruby RUBY_VERSION

gem 'rails', '~> 5.1'
gem 'rails-i18n', '~> 5.0'

gem 'jbuilder', '~> 2.6'
gem 'jquery-rails', '~> 4.3'
gem 'record_tag_helper', '~> 1.0'
gem 'rinku', '~> 2.0'
gem 'uglifier', '~> 4.1'

gem 'dotenv-rails', '~> 2.1'

group :development, :test do
  gem 'byebug', '~> 10.0'
  gem 'capybara', '~> 2.18'
  gem 'factory_bot_rails', '~> 4.8'
  gem 'launchy', '~> 2.4'
  gem 'minitest-hooks', '~> 1.4'
  gem 'minitest-spec-rails', '~> 5.4'
  gem 'rails-controller-testing', '~> 1.0'
  gem 'rubocop', '0.52.1', require: false
  gem 'spring', '~> 2.0'
end

group :test do
  gem 'bullet', '~> 5.7'
  gem 'database_cleaner', '~> 1.6'
  gem 'poltergeist', '~> 1.17'
  gem 'vcr', '~> 4.0'
  gem 'webmock', '~> 3.3'
end

group :production, :staging do
  gem 'airbrake', '~> 7.2'

  # @todo Add a performance monitoring tool
end

group :development do
  gem 'faker', '~> 1.8'
  gem 'i18n-tasks', '0.9.20'
  gem 'listen', '~> 3.1'
  gem 'localeapp', '~> 2.4'

  # deploy
  gem 'capistrano', '~> 3.10'
  gem 'capistrano-rails', '~> 1.3'
  gem 'capistrano-rbenv', '~> 2.1'
  gem 'capistrano-sidekiq', '1.0.0'
end

gem 'http_accept_language', '~> 2.1'
gem 'pg', '0.21.0'
gem 'redis-rails', '~> 5.0'
gem 'sidekiq', '~> 5.1'

gem 'devise', '~> 4.4'
gem 'kaminari', '~> 1.1'
gem 'maxminddb', '0.1.15'

gem 'omniauth', '~> 1.8'
gem 'omniauth-facebook', '~> 4.0'
gem 'omniauth-google-oauth2', '0.5.3'

# Image processing in the background. @todo Properly reenable it
# gem 'delayed_paperclip'

gem 'paperclip', '~> 5.2'
gem 'pundit', '~> 1.1'
gem 'recaptcha', '~> 4.6', require: 'recaptcha/rails'

# Admin backend.
# @todo Get rid of this, possibly by completely ditching activeadmin and
# implementing the console from scratch.
gem 'activeadmin', '~> 1.2'

# For Yahoo YQL interaction
gem 'rest-client', '~> 2.0'

gem 'bootstrap-sass', '~> 3.3'
gem 'sass-rails', '~> 5.0'

# Rake task utils
gem 'rubyzip', '~> 1.2', require: false
