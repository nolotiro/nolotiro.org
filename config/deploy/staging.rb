server 'beta.nolotiro.org', user: 'ruby-data', roles: %w{db web app}

set :stage, :staging
set :rails_env, 'staging' 
set :deploy_to, '/var/www/beta.nolotiro.org'
set :branch, ENV['BRANCH'] || "master"

set :rbenv_type, :user
set :rbenv_ruby, '2.3.0'
