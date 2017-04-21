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

gem 'rails', '~> 5.0'
gem 'rails-i18n', '~> 5.0'

gem 'jbuilder', '~> 2.6'
gem 'jquery-rails'
gem 'record_tag_helper', '~> 1.0' # for `div_for`
gem 'uglifier', '>= 1.3.0'

gem 'dotenv-rails', '~> 2.1'

group :development, :test do
  gem 'byebug'                       # debugger
  gem 'capybara'                     # real user interactions
  gem 'factory_girl_rails', '~> 4.0' # factories
  gem 'launchy'                      # features - save_and_open_page helper
  gem 'minitest-hooks'               # minitest enhancements
  gem 'minitest-spec-rails'          # specs style out-of-the-box
  gem 'rails-controller-testing'     # controller testing gemified for Rails 5
  gem 'spring'                       # speed up things
end

group :test do
  gem 'bullet' # n+1 query problem alert
  gem 'database_cleaner', '~> 1.5'
  gem 'poltergeist'
  gem 'vcr', '~> 3.0'
  gem 'webmock', '~> 3.0'
end

group :production, :staging do
  gem 'airbrake', '~> 4.0' # exception notification

  # @todo Add a performance monitoring tool
end

group :development do
  gem 'brakeman-lib'
  gem 'faker'
  gem 'i18n-tasks', '0.9.5'
  gem 'localeapp'
  # until https://github.com/bbatsov/rubocop/pull/4237 released
  gem 'rubocop', github: 'bbatsov/rubocop'

  # deploy
  gem 'capistrano', '~> 3.0'
  gem 'capistrano-rails'
  gem 'capistrano-rbenv'
  gem 'capistrano-sidekiq'
end

gem 'http_accept_language'
gem 'pg', '0.19.0'         # database adapter
gem 'redis-rails'          # redis cache
gem 'sidekiq'              # job workers

gem 'devise'             # users
gem 'kaminari', '0.17.0' # pagination
gem 'maxminddb'          # geolite city v2

gem 'omniauth'               # users login with providers
gem 'omniauth-facebook'      # users login with facebook
gem 'omniauth-google-oauth2' # users login with google

# Image processing in the background. @todo Properly reenable it
# gem 'delayed_paperclip'

gem 'paperclip', '~> 4.0'                   # images
gem 'pundit'                                # authorization
gem 'recaptcha', require: 'recaptcha/rails' # captcha

# Admin backend.
# @todo Get rid of this, possibly by completely ditching activeadmin and
# implementing the console from scratch.
gem 'activeadmin', github: 'activeadmin'

# For Yahoo YQL interaction
gem 'rest-client', '~> 2.0'

gem 'bootstrap-sass', '~> 3.3'
gem 'sass-rails', '~> 5.0'

# Rake task utils
gem 'rubyzip', require: false
