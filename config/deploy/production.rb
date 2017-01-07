# frozen_string_literal: true

server 'nolotiro.org', user: 'ruby-data', port: 2225, roles: %w(db web app)

set :stage, :production
set :rails_env, 'production'
set :deploy_to, '/var/www/nolotiro.org'
set :branch, 'master'

set :linked_files, %w(.env.production)

if File.exist?('config/deploy/rsa_key')
  set :ssh_options, fetch(:ssh_options).merge(keys: ['config/deploy/rsa_key'])
end

set :rbenv_type, :user
set :rbenv_ruby, '2.3.1'
