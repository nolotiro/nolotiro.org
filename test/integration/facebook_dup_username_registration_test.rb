# frozen_string_literal: true

require 'test_helper'
require 'support/oauth'
require 'integration/concerns/social_dup_username_tests'

class FacebookDupUsernameRegistrationTest < ActionDispatch::IntegrationTest
  include OauthHelpers
  include SocialDupUsernameTests

  before { @provider = :facebook }
end
