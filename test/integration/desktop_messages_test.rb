# frozen_string_literal: true

require 'test_helper'
require 'support/desktop_integration'
require 'integration/concerns/standard_messaging_tests'
require 'integration/concerns/self_messaging_tests'

module DesktopMessagesTest
  class StandardMessagesTest < DesktopIntegrationTest
    include StandardMessagingTests
  end

  class SelfDesktopMessagesTest < DesktopIntegrationTest
    include SelfMessagingTests
  end
end
