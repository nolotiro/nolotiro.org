# frozen_string_literal: true

require 'capybara/poltergeist'
require 'support/desktop_integration'
require 'support/mobile_integration'
require 'minitest/hooks'

# Pickup assets from development server if it's running
Capybara.asset_host = 'http://localhost:3000'

# Poltergeist customization
Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, url_whitelist: ['127.0.0.1'])
end

# Default javascript driver
Capybara.javascript_driver = :poltergeist

module ActionDispatch
  #
  # Base class for integration tests
  #
  class IntegrationTest
    # Make the Capybara DSL available in all integration tests
    include Capybara::DSL

    after { Capybara.reset_sessions! }
  end

  module Routing
    class RouteSet
      def default_url_options(_options = {})
        { locale: I18n.default_locale }
      end
    end
  end
end
