require 'test_helper'
require 'support/oauth'
require 'support/web_mocking'

class FacebookRegistrationTest < ActionDispatch::IntegrationTest
  include OauthHelpers
  include WebMocking

  it 'properly authenticates user when facebook account has an email' do
    login_via_facebook(name: 'pepe', email: 'pepe@facebook.com')

    assert_content 'hola, pepe'
  end

  it 'redirects to a form when facebook account has no email' do
    login_via_facebook(name: 'pepe')

    assert_content <<~MSG
      Necesitamos que indiques una dirección de email para completar el registro
    MSG
  end

  it 'autofills username when facebook account has no email' do
    login_via_facebook(name: 'pepe')

    assert page.has_selector?('input[value=pepe]')
  end

  it 'finishes registration when facebook account has no email' do
    register_through_facebook_when_missing_email('pepe')

    assert_content <<~TEXT
      Se ha enviado un mensaje con un enlace de confirmación a tu correo
      electrónico.
    TEXT
  end

  it 'allows overriding facebook name when facebook account has no email' do
    register_through_facebook_when_missing_email('pepe', 'pepito')

    assert_equal 'pepito', User.first.username
    assert_equal 1, User.count
  end

  it 'requires user to confirm email when facebook account has no email' do
    register_through_facebook_when_missing_email('pepe')
    login_via_facebook(name: 'pepe')

    assert_content 'Tienes que confirmar tu cuenta para poder continuar'
  end

  it 'logs user in after confirming email when facebook account has no email' do
    register_through_facebook_when_missing_email('pepe')
    User.first.confirm
    login_via_facebook(name: 'pepe')

    assert_content 'hola, pepe'
  end

  it 'succesfully links to old user if email already present in db' do
    user = create(:user, username: 'pepito', email: 'pepe@facebook.com')
    mocking_yahoo_woeid_info(user.woeid) do
      login_via_facebook(name: 'pepe', email: 'pepe@facebook.com')
    end

    assert_content 'hola, pepito'
    assert_equal 1, User.count
  end

  private

  def register_through_facebook_when_missing_email(facebook_name, name = nil)
    login_via_facebook(name: facebook_name)
    fill_in 'Tu email', with: "#{facebook_name}@example.com"
    fill_in 'Elige un nombre de usuario', with: name if name
    click_button 'Regístrate'
  end
end
