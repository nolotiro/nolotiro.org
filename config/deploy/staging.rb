server 'beta.nolotiro.org', user: 'ruby-data', roles: %w{db web app}

set :stage, :staging
set :rails_env, 'staging' 
set :deploy_to, '/var/www/beta.nolotiro.org'
set :branch, "staging"

set :rbenv_type, :user
set :rbenv_ruby, '2.1.2'

namespace :deploy do

  desc 'Start application'
  task :start do
    on roles(:app), in: :sequence, wait: 5 do
      sudo "/etc/init.d/unicorn_beta.nolotiro.org.sh start"
    end
  end

  desc 'Stop application'
  task :stop do
    on roles(:app), in: :sequence, wait: 5 do
      sudo "/etc/init.d/unicorn_beta.nolotiro.org.sh stop"
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      sudo "/etc/init.d/god restart"
      sudo "/etc/init.d/unicorn_beta.nolotiro.org.sh stop"
      within release_path do
        execute :rake, 'nolotiro:cache:clear'
      end
      sudo "/etc/init.d/unicorn_beta.nolotiro.org.sh start"
    end
  end

end
