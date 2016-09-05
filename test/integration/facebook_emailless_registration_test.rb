# frozen_string_literal: true

require 'test_helper'
require 'support/oauth'

class FacebookEmaillessRegistrationTest < ActionDispatch::IntegrationTest
  include OauthHelpers

  before { login_via_facebook(name: 'pepe') }

  it 'redirects to a form' do
    assert_text <<~MSG
      Necesitamos que indiques una dirección de email para completar el registro
    MSG
  end

  it 'autofills username' do
    assert_selector 'input[value=pepe]'
  end

  it 'finishes registration' do
    fill_in_finalize_form('pepe@example.com')

    assert_text <<~MSG
      Se ha enviado un mensaje con un enlace de confirmación a tu correo
      electrónico.
    MSG
  end

  it 'allows overriding facebook name in form' do
    fill_in_finalize_form('pepe@example.com', 'pepito')

    assert_equal ['pepito'], User.pluck(:username)
  end

  it 'requires user to confirm email' do
    fill_in_finalize_form('pepe@example.com')
    login_via_facebook(name: 'pepe')

    assert_text 'Tienes que confirmar tu cuenta para poder continuar'
  end

  it 'logs user in after confirming email' do
    fill_in_finalize_form('pepe@example.com')
    User.first.confirm
    login_via_facebook(name: 'pepe')

    assert_text 'hola, pepe'
  end

  private

  def fill_in_finalize_form(email, name = nil)
    fill_in 'Tu email', with: email
    fill_in 'Elige un nombre de usuario', with: name if name
    click_button 'Regístrate'
  end
end
