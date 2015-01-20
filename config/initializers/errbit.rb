Airbrake.configure do |config|
  config.api_key = Rails.application.secrets.airbrake["apikey"]
  config.host    = Rails.application.secrets.airbrake["host"]
  config.port    = Rails.application.secrets.airbrake["port"]
end
