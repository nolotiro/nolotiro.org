# frozen_string_literal: true

require 'test_helper'
require 'support/mobile_integration'
require 'integration/concerns/messaging_tests'

class MobileMessagesTest < MobileIntegrationTest
  include MessagingTests
end
