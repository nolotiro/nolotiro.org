# frozen_string_literal: true
require 'test_helper'
require 'support/oauth'
require 'support/web_mocking'

class FacebookRegistrationTest < ActionDispatch::IntegrationTest
  include OauthHelpers
  include WebMocking

  it 'properly authenticates user when facebook account has an email' do
    login_via_facebook(name: 'pepe', email: 'pepe@facebook.com')

    assert_text 'hola, pepe'
  end

  it 'succesfully links to old user if email already present in db' do
    user = create(:user, username: 'pepito', email: 'pepe@facebook.com')
    mocking_yahoo_woeid_info(user.woeid) do
      login_via_facebook(name: 'pepe', email: 'pepe@facebook.com')
    end

    assert_text 'hola, pepito'
  end
end
