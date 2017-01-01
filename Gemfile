# frozen_string_literal: true

# @todo Revisited the warnings fixed by this in Bundler 2, I guess they will be
# fixed and this won't be needed
#
git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')

  "https://github.com/#{repo_name}.git"
end

source 'https://rubygems.org'

ruby '2.3.1'

gem 'rails', '~> 5.0'
gem 'rails-i18n', '~> 5.0'

gem 'jbuilder', '~> 2.6'
gem 'jquery-rails'
gem 'record_tag_helper', '~> 1.0' # for `div_for`
gem 'uglifier', '>= 1.3.0'

gem 'dotenv-rails', '~> 2.1'

group :doc do
  gem 'sdoc', require: false
end

group :console do
  gem 'table_print'
end

group :development, :test do
  gem 'byebug'                       # dev: debugger
  gem 'capybara'                     # test: real user interactions
  gem 'factory_girl_rails', '~> 4.0' # test: factories
  gem 'launchy'                      # test: features - save_and_open_page helper
  gem 'minitest-hooks'               # test: minitest enhancements
  gem 'minitest-spec-rails'          # test: specs style out-of-the-box
  gem 'rails-controller-testing'     # controller testing gemified for Rails 5
  gem 'spring'                       # dev: speed up things
end

group :test do
  gem 'bullet' # n+1 query problem alert
  gem 'database_cleaner', '~> 1.5'
  gem 'poltergeist'
  gem 'vcr', '~> 3.0'
  gem 'webmock', '~> 2.0'
end

group :production, :staging do
  gem 'airbrake', '~> 4.0' # exception notification
  gem 'newrelic_rpm'       # monitoring
end

group :development do
  gem 'brakeman-lib'
  gem 'faker'
  gem 'i18n-tasks', '0.9.5'
  gem 'localeapp',
      github: 'deivid-rodriguez/localeapp',
      branch: 'drop_1.9.3_support' # i18n interface
  gem 'rubocop', '0.46.0'

  # deploy
  gem 'capistrano', '~> 3.0'
  gem 'capistrano-pending'
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

gem 'delayed_paperclip'                     # images processing in background
gem 'paperclip', '~> 4.0'                   # images
gem 'pundit'                                # authorization
gem 'recaptcha', require: 'recaptcha/rails' # captcha

# Admin backend. Adding inherited resources master for Rails 5 support until
# they starting releasing things. @todo Get rid of this, possibly by completely
# ditching activeadmin and implementing the console from scratch.
gem 'activeadmin', github: 'activeadmin'
gem 'inherited_resources', github: 'activeadmin/inherited_resources'

# For Yahoo YQL interaction
gem 'json', '~> 1.8'
gem 'rest-client', '~> 2.0'

gem 'bootstrap-sass', '~> 3.3'
gem 'sass-rails', '~> 5.0'

# Rake task utils
gem 'rubyzip', require: false
