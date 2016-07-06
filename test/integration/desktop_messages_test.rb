# frozen_string_literal: true
require 'test_helper'
require 'support/desktop_integration'
require 'integration/concerns/messages'

class DesktopMessagesTest < DesktopIntegrationTest
  include Messages
end
