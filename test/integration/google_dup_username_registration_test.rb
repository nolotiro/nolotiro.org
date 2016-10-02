# frozen_string_literal: true

require 'test_helper'
require 'support/oauth'
require 'integration/concerns/social_dup_username_tests'

class GoogleDupUsernameRegistrationTest < ActionDispatch::IntegrationTest
  include OauthHelpers
  include SocialDupUsernameTests

  before { @provider = :google }
end
