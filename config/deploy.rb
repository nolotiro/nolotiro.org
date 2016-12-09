# frozen_string_literal: true

set :application, 'nolotiro.org'
set :repo_url, 'https://github.com/alabs/nolotiro.org'

set :format, :pretty
set :log_level, :debug
set :pty, true

set :deploy_via, :remote_cache

set :ssh_options, forward_agent: true

set :linked_dirs, %w(log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/legacy)

set :bundle_binstubs, nil
set :keep_releases, 5

# Logical flow for deploying an app
before 'deploy:publishing', 'deploy:max_mind:extract'
after  'deploy:finished', 'deploy:restart'

namespace :deploy do
  namespace :max_mind do
    desc 'Extract MaxMind DB for source compressed file'
    task :extract do
      on roles(:app) do
        within release_path do
          with rails_env: fetch(:rails_env) do
            execute :rake, 'max_mind:extract'
          end
        end
      end
    end
  end

  desc 'Start application'
  task :start do
    on roles(:app) do
      sudo 'service nginx start'
    end
  end

  desc 'Stop application'
  task :stop do
    on roles(:app) do
      sudo 'service nginx stop'
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app) do
      sudo 'service nginx restart'
    end
  end

  before :restart, :clear_cache do
    on roles(:app) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'cache:clear'
        end
      end
    end
  end
end
