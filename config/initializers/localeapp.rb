# frozen_string_literal: true

if Rails.env.development?
  require_relative '../application'
  require 'localeapp/rails'

  Localeapp.configure do |config|
    config.api_key = Rails.application.secrets['localeapp_apikey']
    config.polling_environments = []
    config.sending_environments = []
    config.reloading_environments = []
    config.cache_missing_translations = true
  end
end
