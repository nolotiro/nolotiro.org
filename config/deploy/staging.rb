# frozen_string_literal: true

server 'beta.nolotiro.org', user: 'ruby-data', port: 2226, roles: %w[db web app]

set :stage, :staging
set :rails_env, 'staging'
set :deploy_to, '/var/www/beta.nolotiro.org'
set :branch, -> { `git rev-parse --abbrev-ref HEAD`.chomp }

set :linked_files, %w[.env.staging]

set :rbenv_type, :user
