source 'https://rubygems.org'

ruby '2.2.3'

gem 'bundler', '>= 1.8.4'
gem 'rails', '~> 4.2'
gem 'haml-rails'
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'therubyracer', platforms: :ruby
gem 'jquery-rails'
#gem 'turbolinks'
gem 'jbuilder', '~> 1.2'
gem 'rb-readline', '~> 0.5.0', :require => false

group :doc do
  gem 'sdoc', require: false
end

group :development, :test do
  gem 'sqlite3'                             # test: database
  gem 'minitest-rails-capybara'             # test: features
  gem 'capybara'                            # test: features
  gem 'capybara-webkit'                     # test: features - js: true
  gem 'launchy'                             # test: features - save_and_open_page helper
  gem 'factory_girl_rails', '~> 4.0'        # test: factories 
  gem 'minitest-reporters'                  # test: color output 
  gem 'database_cleaner'                    # test: for not having duplicity
  gem 'byebug'                              # dev: debugger
  gem 'spring'                              # dev: speed up things
  gem 'commands'                            # dev: rake commands in console 
  gem 'rails-footnotes', '~> 4.0'           # dev: debug messages on HTML
  gem 'web-console', '~> 2.0'               # dev: better errors
  #gem 'better_errors'                       # dev: better errors
  #gem 'binding_of_caller'                   # dev: better errors
  gem 'mailcatcher'                         # dev: mailbox 
  gem 'bullet'                              # dev: n+1 query problem alert 
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'


# deploy
gem 'capistrano', '~> 3.0'
gem 'capistrano-rbenv'
gem 'capistrano-rails'
gem 'capistrano-bundler'

gem 'newrelic_rpm'                                  # monitoring
gem 'actionpack-page_caching'                       # caching
gem 'actionpack-action_caching'                     # caching
gem 'unicorn'                                       # webserver
gem 'mysql2', '~> 0.3.18'                           # database adapter
gem 'thinking-sphinx'                               # sphinxsearch
gem 'redis-rails'                                   # redis cache
gem 'resque', github: 'resque/resque', branch: '1-x-stable', require: 'resque/server'              # job workers redis
gem 'sidekiq'
gem 'sinatra', require: false
gem 'slim'

gem 'geoplanet'                                     # yahoo woeid geoplanet
gem 'geoip'                                         # geolite city
gem 'will_paginate', '~> 3.0'                       # pagination
gem 'devise'                                        # users
gem 'devise-async', github: 'mhfs/devise-async'     # send mails async
gem 'omniauth'                                      # users login with providers
gem 'omniauth-facebook'                             # users login with facebook
gem 'omniauth-google-oauth2'                        # users login with google
gem 'cancancan', '~> 1.10'                          # authorization# authorization# authorization
gem 'paperclip', '~> 4.0'                           # images
gem 'delayed_paperclip'                             # images processing in bacground
gem 'recaptcha', :require => 'recaptcha/rails'      # captcha
gem 'airbrake'                                      # exception notification
gem 'paranoia', '~> 2.0'                            # don't really delete a model
gem 'ipaddress'                                     # ip address validation
gem 'localeapp'                                     # i18n interface
gem 'blueprint-rails'                               # blueprint css framework
gem 'activeadmin', github: 'activeadmin'            # admin backend
gem 'active_skin'                                   # admin backend skin
gem 'rakismet'                                      # antispam
gem 'font-awesome-rails'                            # font-awesome icons

# https://github.com/mailboxer/mailboxer/issues/316
#gem 'mailboxer'                                     # messaging
gem 'mailboxer', :git => 'git://github.com/div/mailboxer.git', :branch => 'rails42-foreigner' 

source 'https://rails-assets.org' do
  gem 'rails-assets-bootstrap'
end

