# frozen_string_literal: true

require 'test_helper'
require 'support/desktop_integration'
require 'integration/concerns/standard_messages'
require 'integration/concerns/self_messages'

module DesktopMessagesTest
  class StandardMessagesTest < DesktopIntegrationTest
    include StandardMessages
  end

  class SelfDesktopMessagesTest < DesktopIntegrationTest
    include SelfMessages
  end
end
