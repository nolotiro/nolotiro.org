# frozen_string_literal: true
set :application, 'nolotiro.org'
set :repo_url, 'https://github.com/alabs/nolotiro.org'

ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

set :scm, :git

set :format, :pretty
set :log_level, :debug
set :pty, true

#set :deploy_via, :copy
set :deploy_via, :remote_cache

set :ssh_options, { forward_agent: true }

set :linked_files, %w{config/database.yml config/secrets.yml config/newrelic.yml}
set :linked_dirs, %w{db/sphinx log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/legacy vendor/geolite}

set :bundle_binstubs, nil
set :keep_releases, 5

set :ci_client, 'travis'
set :ci_repository, 'alabs/nolotiro.org'

# Logical flow for deploying an app
before 'deploy', 'ci:verify'
after  'deploy:finished',            'thinking_sphinx:index'
after  'deploy:finished',            'thinking_sphinx:restart'
after  'deploy:finished',            'deploy:restart'

namespace :deploy do

  desc 'Perform migrations'
  task :migrations do
    on roles(:db) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'db:migrate'
        end
      end
    end
  end

  desc 'Start application'
  task :start do
    on roles(:app), in: :sequence, wait: 5 do

      # starting nginx / passenger
      sudo 'service nginx start'

      # starting sidekiq / unicorn
      sudo 'service god start'

    end
  end

  desc 'Stop application'
  task :stop do
    on roles(:app), in: :sequence, wait: 5 do

      # stoping nginx / passenger
      sudo 'service nginx stop'

      # stoping sidekiq / unicorn
      sudo 'service god stop'

    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # restarting nginx / passenger
      sudo 'service nginx restart'

      # restarting sidekiq / unicorn
      sudo 'service god restart'
    end
  end

  before :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'nolotiro:cache:clear'
        end
      end
    end
  end

  after :finishing, 'deploy:cleanup'
end
