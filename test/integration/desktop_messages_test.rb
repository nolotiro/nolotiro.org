# frozen_string_literal: true

require 'test_helper'
require 'support/desktop_integration'
require 'integration/concerns/messaging_tests'

class DesktopMessagesTest < DesktopIntegrationTest
  include MessagingTests
end
