# frozen_string_literal: true

server "prod-nolotiro", user: "ruby-data", roles: %w[db web app]
set :branch, "master"
set :rails_env, "production"
