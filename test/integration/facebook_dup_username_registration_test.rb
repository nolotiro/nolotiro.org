# frozen_string_literal: true
require 'test_helper'
require 'support/oauth'
require 'support/web_mocking'

class FacebookDupUsernameRegistrationTest < ActionDispatch::IntegrationTest
  include OauthHelpers
  include WebMocking

  before do
    create(:user, username: 'pepe', email: 'pepe@example.org')
    login_via_facebook(name: 'pepe', email: 'pepe@facebook.com')
  end

  it 'redirects to a form' do
    assert_content <<~MSG
      Tu nombre de usuario de facebook ya se encuentra en nuestra base de datos.
      Si te has registrado ya usando otra red social o mediante email y
      contraseña, por favor, inicia sesión de esa manera. En caso contrario,
      indica otro nombre de usuario para completar el registro.
    MSG
  end

  it 'finalizes registration properly' do
    fill_in 'Elige un nombre de usuario', with: 'pepe_nolotiro'
    click_button 'Regístrate'

    assert_content 'hola, pepe_nolotiro'
  end
end
