require 'localeapp/rails'

Localeapp.configure do |config|
  config.api_key = APP_CONFIG["localeapp_apikey"]
end
