require 'localeapp/rails'

Localeapp.configure do |config|
  config.api_key = Rails.application.secrets["localeapp_apikey"]

  config.polling_environments = []
  config.sending_environments = []
  config.reloading_environments = []
  config.cache_missing_translations = true
end
