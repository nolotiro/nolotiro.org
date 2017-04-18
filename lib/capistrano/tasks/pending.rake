# frozen_string_literal: true

namespace :deploy do
  desc 'Shortcut to deploy:pending:log'
  task pending: 'deploy:pending:log'

  namespace :pending do
    def git(command, from:, to:)
      ::Kernel.exec 'git', command, "#{from}..#{to}"
    end

    def ensure_revision
      if test "test -f #{current_path}/REVISION"
        yield
      else
        error "REVISION file doesn't exist"
        exit 1
      end
    end

    desc <<-DESC
      Display the commits since your last deploy. This is good for a summary \
      of the changes that have occurred since the last deploy.
    DESC
    task log: :capture_revision do
      git('log', from: fetch(:revision), to: fetch(:branch))
    end

    desc <<-DESC
      Display the diff since your last deploy. This is useful if you want to \
      examine what changes are about to be deployed.
    DESC
    task diff: :capture_revision do
      git('diff', from: fetch(:revision), to: fetch(:branch))
    end

    task :capture_revision do
      on roles(:app) do
        ensure_revision do
          within current_path do
            set :revision, capture(:cat, 'REVISION')
          end
        end
      end
    end
  end
end
