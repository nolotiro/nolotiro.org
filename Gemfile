# frozen_string_literal: true

# @todo Revisit the warnings fixed by this in Bundler 2, I guess they will be
# fixed and this won't be needed
#
git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')

  "https://github.com/#{repo_name}.git"
end

source 'https://rubygems.org'

ruby RUBY_VERSION

gem 'rails', '~> 5.1'
gem 'rails-i18n', '~> 5.0'

gem 'jbuilder', '~> 2.6'
gem 'jquery-rails', '~> 4.3'
gem 'record_tag_helper', '~> 1.0'
gem 'rinku', '~> 2.0'
gem 'uglifier', '~> 3.2'

gem 'dotenv-rails', '~> 2.1'

group :development, :test do
  gem 'byebug', '~> 9.1'
  gem 'capybara', '~> 2.15'
  gem 'factory_girl_rails', '~> 4.0'
  gem 'launchy', '~> 2.4'
  gem 'minitest-hooks', '~> 1.4'
  gem 'minitest-spec-rails', '~> 5.4'
  gem 'rails-controller-testing', '~> 1.0'
  gem 'spring', '~> 2.0'
end

group :test do
  gem 'bullet', '~> 5.6'
  gem 'database_cleaner', '~> 1.5'
  gem 'poltergeist', '~> 1.16'
  gem 'vcr', '~> 3.0'
  gem 'webmock', '~> 3.0'
end

group :production, :staging do
  gem 'airbrake', '~> 6.0'

  # @todo Add a performance monitoring tool
end

group :development do
  gem 'brakeman-lib', '~> 3.7'
  gem 'faker', '~> 1.8'
  gem 'i18n-tasks', '= 0.9.18'
  gem 'listen', '~> 3.1'
  gem 'localeapp', '~> 2.4'
  gem 'rubocop', '= 0.49.1'

  # deploy
  gem 'capistrano', '~> 3.0'
  gem 'capistrano-rails', '~> 1.3'
  gem 'capistrano-rbenv', '~> 2.1'
  gem 'capistrano-sidekiq', '= 0.20.0'
end

gem 'http_accept_language', '~> 2.1'
gem 'pg', '= 0.19.0'
gem 'redis-rails', '~> 5.0'
gem 'sidekiq', '~> 4.2'

gem 'devise', '~> 4.3'
gem 'kaminari', '~> 1.0'
gem 'maxminddb', '= 0.1.12'

gem 'omniauth', '~> 1.3'
gem 'omniauth-facebook', '~> 4.0'
gem 'omniauth-google-oauth2', '= 0.5.2'

# Image processing in the background. @todo Properly reenable it
# gem 'delayed_paperclip'

gem 'paperclip', '~> 5.1'
gem 'pundit', '~> 1.1'
gem 'recaptcha', '~> 3.3', require: 'recaptcha/rails'

# Admin backend.
# @todo Get rid of this, possibly by completely ditching activeadmin and
# implementing the console from scratch.
gem 'activeadmin', '~> 1.0'

# For Yahoo YQL interaction
gem 'rest-client', '~> 2.0'

gem 'bootstrap-sass', '~> 3.3'
gem 'sass-rails', '~> 5.0'

# Rake task utils
gem 'rubyzip', '~> 1.2', require: false
