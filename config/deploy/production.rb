# frozen_string_literal: true
server 'nolotiro.org', user: 'ruby-data', roles: %w{db web app}

set :stage, :production
set :rails_env, 'production'
set :deploy_to, '/var/www/nolotiro.org'
set :branch, 'master'

set :rbenv_type, :user
set :rbenv_ruby, '2.3.1'
