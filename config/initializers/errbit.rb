# frozen_string_literal: true

if Rails.env.production? || Rails.env.staging?
  Airbrake.configure do |config|
    config.api_key = ENV['AIRBRAKE_APIKEY']
    config.host    = ENV['AIRBRAKE_HOST']
    config.port    = ENV['AIRBRAKE_PORT'].to_i
    config.secure  = config.port == 443
  end
end
