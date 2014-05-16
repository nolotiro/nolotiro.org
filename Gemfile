source 'https://rubygems.org'

gem 'rails', '4.0.1'
gem 'sqlite3'
gem 'haml-rails'
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'therubyracer', platforms: :ruby
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 1.2'

group :doc do
  gem 'sdoc', require: false
end

group :development, :test do

  gem 'factory_girl_rails', '~> 4.0'        # test: factories 
  gem 'turn'                                # test: color output
  gem 'database_cleaner'                    # test: for not having duplicity

  gem 'debugger'                            # dev: debugger
  gem 'zeus', '>= 0.13.4.pre2'              # dev: speed up sthings
  gem 'commands'                            # dev: rake commands in console 
  # rails-footnotes: using github master
  #                  until this issue is in gem repo
  #                  https://github.com/josevalim/rails-footnotes/pull/93
  gem 'rails-footnotes', git: "https://github.com/josevalim/rails-footnotes"                     # dev: data at footnote
  gem 'better_errors'                       # dev: better errors
  gem 'binding_of_caller'                   # dev: better errors
  gem 'mailcatcher'                         # dev: mailbox 

end

group :production do
  gem 'newrelic_rpm'                        # prod: monitoring
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'


# deploy
gem 'capistrano', '~> 3.0'
gem 'capistrano-rvm', '~> 0.0.3'
gem 'capistrano-rails'
gem 'capistrano-bundler'

gem 'actionpack-page_caching'                       # caching
gem 'actionpack-action_caching'                     # caching
gem 'unicorn'                                       # webserver
gem 'mysql2'                                        # mysql
gem 'thinking-sphinx'                               # sphinxsearch
gem 'redis-rails'                                   # redis cache
gem 'resque', require: 'resque/server'              # job workers redis

gem 'geoplanet'                                     # yahoo woeid geoplanet
gem 'geoip'                                         # geolite city
gem 'will_paginate', '~> 3.0'                       # pagination
gem 'devise'                                        # users
gem 'devise-async'                                  # send mails async
gem 'cancan'                                        # authorization
gem 'paperclip', '~> 3.0'                           # images
gem 'delayed_paperclip'                             # images processing in bacground
gem 'recaptcha', :require => 'recaptcha/rails'      # captcha
gem 'airbrake'                                      # exception notification
gem 'paranoia', '~> 2.0'                            # don't really delete a model
gem 'ipaddress'                                     # ip address validation
gem 'mailboxer'                                     # messaging
gem 'rb-readline'                                   # fix rails console error

gem 'blueprint-rails'                               # blueprint css framework
