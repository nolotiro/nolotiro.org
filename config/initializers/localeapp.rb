require_relative '../application'
require 'localeapp/rails'

Localeapp.configure do |config|
  config.api_key = if Rails.env.test?
                     'a' * 50
                   else
                     Rails.application.secrets["localeapp_apikey"]
                   end

  config.polling_environments = []
  config.sending_environments = []
  config.reloading_environments = []
  config.cache_missing_translations = true
end
