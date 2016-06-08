require 'test_helper'
require 'support/oauth'

class FacebookStandardRegistrationTest < ActionDispatch::IntegrationTest
  include OauthHelpers

  before { OmniAuth.config.test_mode = true }

  it 'properly authenticates user' do
    mock_facebook(name: 'pepe', email: 'pepe@facebook.com')
    visit user_omniauth_authorize_path(provider: 'facebook')

    assert page.has_content?('hola, pepe')
  end
end
