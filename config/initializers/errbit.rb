# frozen_string_literal: true

if Rails.env.production? || Rails.env.staging?
  Airbrake.configure do |config|
    config.api_key = Rails.application.secrets.airbrake['apikey']
    config.host    = Rails.application.secrets.airbrake['host']
    config.port    = Rails.application.secrets.airbrake['port']
    config.secure  = config.port == 443
  end
end
