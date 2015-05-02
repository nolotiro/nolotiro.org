require 'capistrano/setup'
require 'capistrano/deploy'

#   https://github.com/capistrano/rvm
#   https://github.com/capistrano/bundler
#   https://github.com/capistrano/rails/tree/master/assets
#   https://github.com/capistrano/rails/tree/master/migrations
#
require 'capistrano/rbenv'
require 'capistrano/bundler'
require 'capistrano/rails'

require 'thinking_sphinx/capistrano'

# FIXME: undefined method `instance' for Capistrano::Configuration:Class 
# require 'thinking_sphinx/capistrano'

Dir.glob('lib/capistrano/tasks/*.cap').each { |r| import r }
