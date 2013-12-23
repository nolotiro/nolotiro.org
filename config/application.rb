require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module NolotiroOrg
  class Application < Rails::Application
    config.time_zone = 'Madrid'
    config.i18n.default_locale = :es
  end
end
