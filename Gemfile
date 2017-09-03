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
gem 'jquery-rails'
gem 'record_tag_helper', '~> 1.0'
gem 'rinku', '~> 2.0'
gem 'uglifier', '>= 1.3.0'

gem 'dotenv-rails', '~> 2.1'

group :development, :test do
  gem 'byebug'
  gem 'capybara'
  gem 'factory_girl_rails', '~> 4.0'
  gem 'launchy'
  gem 'minitest-hooks'
  gem 'minitest-spec-rails'
  gem 'rails-controller-testing'
  gem 'spring'
end

group :test do
  gem 'bullet'
  gem 'database_cleaner', '~> 1.5'
  gem 'poltergeist'
  gem 'vcr', '~> 3.0'
  gem 'webmock', '~> 3.0'
end

group :production, :staging do
  gem 'airbrake', '~> 6.0'

  # @todo Add a performance monitoring tool
end

group :development do
  gem 'brakeman-lib'
  gem 'faker'
  gem 'i18n-tasks', '0.9.5'
  gem 'listen'
  gem 'localeapp'
  gem 'rubocop', '0.49.1'

  # deploy
  gem 'capistrano', '~> 3.0'
  gem 'capistrano-rails'
  gem 'capistrano-rbenv'
  gem 'capistrano-sidekiq'
end

gem 'http_accept_language'
gem 'pg', '0.19.0'
gem 'redis-rails'
gem 'sidekiq'

gem 'devise'
gem 'kaminari', '~> 1.0'
gem 'maxminddb'

gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'

# Image processing in the background. @todo Properly reenable it
# gem 'delayed_paperclip'

gem 'paperclip', '~> 4.0'
gem 'pundit',
gem 'recaptcha', require: 'recaptcha/rails'

# Admin backend.
# @todo Get rid of this, possibly by completely ditching activeadmin and
# implementing the console from scratch.
gem 'activeadmin', '~> 1.0'

# For Yahoo YQL interaction
gem 'rest-client', '~> 2.0'

gem 'bootstrap-sass', '~> 3.3'
gem 'sass-rails', '~> 5.0'

# Rake task utils
gem 'rubyzip', require: false
