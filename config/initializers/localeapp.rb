# frozen_string_literal: true

require_relative '../environment'

if Rails.env.development?
  Localeapp.configure do |config|
    config.api_key = ENV['LOCALEAPP_APIKEY']

    config.translation_data_directory = 'config/locales'

    config.polling_environments = []
    config.sending_environments = []
    config.reloading_environments = []
    config.cache_missing_translations = true
  end
end
