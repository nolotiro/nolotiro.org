set :stage, :production
set :rails_env, 'production' 
server 'beta.nolotiro.org', user: 'ruby-data', roles: %w{db web app} #, my_property: :my_value
set :deploy_to, '/var/www/nolotiro.org'
set :branch, "deploy"
