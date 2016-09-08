# frozen_string_literal: true

set :application, 'nolotiro.org'
set :repo_url, 'https://github.com/alabs/nolotiro.org'

ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

set :scm, :git

set :format, :pretty
set :log_level, :debug
set :pty, true

# set :deploy_via, :copy
set :deploy_via, :remote_cache

set :ssh_options, forward_agent: true

set :linked_files, %w(config/database.yml config/secrets.yml config/newrelic.yml)
set :linked_dirs, %w(log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/legacy vendor/geolite)

set :bundle_binstubs, nil
set :keep_releases, 5

set :ci_client, 'travis'
set :ci_repository, 'alabs/nolotiro.org'

# Logical flow for deploying an app
before 'deploy', 'ci:verify'
after  'deploy:finished', 'deploy:restart'

namespace :deploy do
  desc 'Start application'
  task :start do
    on roles(:app), in: :sequence, wait: 5 do
      sudo 'service nginx start'
    end
  end

  desc 'Stop application'
  task :stop do
    on roles(:app), in: :sequence, wait: 5 do
      sudo 'service nginx stop'
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      sudo 'service nginx restart'
    end
  end
end
