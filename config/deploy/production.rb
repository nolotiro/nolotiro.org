set :stage, :production
set :rails_env, 'production' 
server 'beta.nolotiro.org', user: 'ruby-data', roles: %w{db web app} #, my_property: :my_value
