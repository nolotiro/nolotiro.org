# frozen_string_literal: true

require 'integration/concerns/authenticated_test'

class JsAuthenticatedTest < AuthenticatedTest
  before do
    Capybara.current_driver = Capybara.javascript_driver
  end

  after { Capybara.current_driver = Capybara.default_driver }
end
