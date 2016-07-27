# frozen_string_literal: true
require 'test_helper'
require 'support/mobile_integration'
require 'integration/concerns/standard_messages'
require 'integration/concerns/self_messages'

module MobileMessagesTest
  class StandardMessagesTest < DesktopIntegrationTest
    include StandardMessages
  end

  class SelfDesktopMessagesTest < DesktopIntegrationTest
    include SelfMessages
  end
end
