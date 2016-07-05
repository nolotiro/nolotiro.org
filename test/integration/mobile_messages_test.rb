# frozen_string_literal: true
require 'test_helper'
require 'support/mobile_integration'
require 'integration/concerns/messages'

class MobileMessagesTest < MobileIntegrationTest
  include Messages
end
