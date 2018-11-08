# frozen_string_literal: true

Sidekiq.configure_server do |config|
  config.redis = { url: ENV["REDIS_URL"], password: ENV["REDIS_PASS"] }
end
Sidekiq.configure_client do |config|
  config.redis = { url: ENV["REDIS_URL"], password: ENV["REDIS_PASS"] }
end
