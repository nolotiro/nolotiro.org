# frozen_string_literal: true
require 'capybara/poltergeist'
require 'support/desktop_integration'
require 'support/mobile_integration'
require 'support/assertions'

module ActionDispatch
  #
  # Base class for integration tests
  #
  class IntegrationTest
    # Make the Capybara DSL available in all integration tests
    include Capybara::DSL

    after do
      Capybara.reset_sessions!
      Rails.cache.clear
    end
  end

  module Routing
    class RouteSet
      def default_url_options(_options = {})
        { locale: I18n.default_locale }
      end
    end
  end
end
