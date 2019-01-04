# frozen_string_literal: true

server "stag-nolotiro", user: "ruby-data", roles: %w[db web app]
set :branch, "staging"
set :rails_env, "staging"
