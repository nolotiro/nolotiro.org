require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module NolotiroOrg
  class Application < Rails::Application
    config.time_zone = 'Madrid'
    config.i18n.default_locale = :es
    config.i18n.enforce_available_locales = true
    I18n.config.enforce_available_locales = true
  end
end
