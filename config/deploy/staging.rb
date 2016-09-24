# frozen_string_literal: true

server 'beta.nolotiro.org', user: 'ruby-data', roles: %w(db web app)

set :stage, :staging
set :rails_env, 'staging'
set :deploy_to, '/var/www/beta.nolotiro.org'
ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

set :rbenv_type, :user
set :rbenv_ruby, '2.3.1'
