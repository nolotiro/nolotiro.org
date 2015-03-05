require 'localeapp/rails'

Localeapp.configure do |config|
  config.api_key = APP_CONFIG["localeapp_apikey"]
  config.sending_environments = [:staging]
  config.reloading_environments = []
  config.cache_missing_translations = true
end
