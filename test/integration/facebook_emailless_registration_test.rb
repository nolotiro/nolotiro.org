require 'test_helper'
require 'support/oauth'

class FacebookEmaillessRegistrationTest < ActionDispatch::IntegrationTest
  include OauthHelpers

  before do
    OmniAuth.config.test_mode = true
    mock_facebook(name: 'pepe')
    visit user_omniauth_authorize_path(provider: 'facebook')
  end

  it 'shows an error' do
    message = <<-EOM.squish
      No pudimos registrarte por Facebook porque no tienes una dirección de
      correo electrónico confirmada. Añade una dirección de correo a tu
      cuenta de Facebook o regístrate con tu email
    EOM

    assert page.has_content?(message)
  end

  it 'redirects to email registration form' do
    content = 'Por favor, rellena este formulario para ser miembro de nolotiro'

    assert page.has_content?(content)
  end

  it "autofills form with user's Facebook name" do
    assert page.has_selector?('input[value=pepe]')
  end
end
