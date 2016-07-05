require 'capybara/poltergeist'
require 'support/desktop_integration'
require 'support/mobile_integration'

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

    def assert_content(text)
      msg = "Content '#{text}' was not found in page's content: '#{page.text}'"
      assert page.has_content?(text), msg
    end
  end

  class Routing::RouteSet
    def default_url_options(options={})
      {:locale => I18n.default_locale }
    end
  end
end
