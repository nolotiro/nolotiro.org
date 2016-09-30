# frozen_string_literal: true

require 'test_helper'
require 'integration/concerns/social_registration_tests'

class FacebookRegistrationTest < ActionDispatch::IntegrationTest
  include SocialRegistrationTests

  before { @provider = :facebook }
end
