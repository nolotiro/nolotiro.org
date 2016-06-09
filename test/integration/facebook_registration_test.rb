require 'test_helper'
require 'support/oauth'

class FacebookRegistrationTest < ActionDispatch::IntegrationTest
  include OauthHelpers

  it 'properly authenticates user when facebook account has an email' do
    login_via_facebook(name: 'pepe', email: 'pepe@facebook.com')

    assert page.has_content?('hola, pepe')
  end

  it 'redirects to registration form when facebook account has no email' do
    login_via_facebook(name: 'pepe')

    content = 'Por favor, rellena este formulario para ser miembro de nolotiro'
    assert_content(content)
  end

  it 'autofills username when facebook account has no email' do
    login_via_facebook(name: 'pepe')

    assert page.has_selector?('input[value=pepe]')
  end
end
