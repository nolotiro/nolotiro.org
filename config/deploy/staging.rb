set :stage, :staging
set :rails_env, 'staging' 
server 'beta.nolotiro.org', user: 'ruby-data', roles: %w{db web app} #, my_property: :my_value
set :deploy_to, '/var/www/beta.nolotiro.org'
set :branch, "staging"
