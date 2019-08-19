# frozen_string_literal: true

set :application, "nolotiro.org"
set :repo_url, "https://github.com/alabs/nolotiro.org"
set :deploy_to, "/home/ruby-data/app"

append :linked_files, "config/application.yml", "vendor/geolite/GeoLite2-City.mmdb", "public/ads.txt"
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "public/uploads", "public/legacy", "vendor/bundle"

set :keep_releases, 5
set :puma_bind, "tcp://0.0.0.0:3000"
set :puma_user, fetch(:user)

# Logical flow for deploying an app
# before "deploy:publishing", "deploy:max_mind:extract"

# namespace :deploy do
#   namespace :max_mind do
#     desc "Extract MaxMind DB for source compressed file"
#     task :extract do
#       on roles(:app) do
#         within release_path do
#           with rails_env: fetch(:rails_env) do
#             execute :rake, "max_mind:extract"
#           end
#         end
#       end
#     end
#   end
# end
