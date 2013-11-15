Airbrake.configure do |config|
  config.api_key = APP_CONFIG["airbrake_apikey"]
  config.host    = APP_CONFIG["airbrake_host"]
  config.port    = APP_CONFIG["airbrake_port"]
end
