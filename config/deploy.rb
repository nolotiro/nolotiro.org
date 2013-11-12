set :application, 'nolotiro.org'
set :repo_url, 'git@github.com:alabs/nolotiro.org.git'

# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

set :deploy_to, '/var/www/beta.nolotiro.org'
set :scm, :git

set :format, :pretty
#set :log_level, :debug
set :pty, true

#set :deploy_via, :copy
set :deploy_via, :remote_cache

set :ssh_options, { :forward_agent => true }

set :linked_files, %w{config/database.yml config/app_config.yml vendor/geolite/GeoLiteCity.dat}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

set :keep_releases, 5

set :rvm_type, :user
set :rvm_ruby_version, '2.0.0@nolotiro'

server "beta.nolotiro.org", roles: [:app, :web, :db]

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      sudo "/etc/init.d/unicorn_beta.nolotiro.org.sh restart"
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
#      within release_path do
#        execute :rake, 'cache:clear'
#      end
    end
  end

  after :finishing, 'deploy:cleanup'

end
