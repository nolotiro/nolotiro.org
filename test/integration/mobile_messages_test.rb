# frozen_string_literal: true

require 'test_helper'
require 'support/mobile_integration'
require 'integration/concerns/messaging_tests'

class MobileMessagesTest < MobileIntegrationTest
  include MessagingTests

  #
  # In mobile screens, sometimes the cookie-bar gets in the middle so we need
  # to dismiss it first.
  #
  before do
    visit root_path

    within('#cookie-bar') { click_link 'OK' }
  end
end
