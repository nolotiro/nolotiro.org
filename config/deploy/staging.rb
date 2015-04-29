server 'beta.nolotiro.org', user: 'ruby-data', roles: %w{db web app}

set :stage, :staging
set :rails_env, 'staging' 
set :deploy_to, '/var/www/beta.nolotiro.org'
set :branch, "staging"

set :rbenv_type, :user
set :rbenv_ruby, '2.2.2'
