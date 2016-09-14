# frozen_string_literal: true

require 'test_helper'
require 'support/mobile_integration'
require 'integration/concerns/standard_messaging_tests'
require 'integration/concerns/self_messaging_tests'

module MobileMessagesTest
  class StandardMessagesTest < MobileIntegrationTest
    include StandardMessagingTests
  end

  class SelfDesktopMessagesTest < MobileIntegrationTest
    include SelfMessagingTests
  end
end
