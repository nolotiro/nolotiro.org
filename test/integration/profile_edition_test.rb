# frozen_string_literal: true
require 'test_helper'

require 'integration/concerns/authentication'

class ProfileEditionTest < ActionDispatch::IntegrationTest
  include Authentication

  before do
    user = create(:user, username: 'teresa_electricista',
                         password: 'topsecret',
                         email: 'terec@example.com')
    login_as(user)
  end

  after { logout }

  it 'allows changing the username' do
    submit_form(username: 'teresa_fontanera', password: 'topsecret')

    assert_text 'Tu cuenta fue actualizada'
    assert_equal 'teresa_fontanera', User.first.username
  end

  it 'does not change email inmediately' do
    submit_form(email: 'terfo@example.com', password: 'topsecret')

    message = <<-MSG.squish
      Has actualizado tu cuenta correctamente, pero es necesario confirmar tu
      nuevo correo electrónico. Por favor, comprueba tu correo y sigue el enlace
      de confirmación para finalizar la comprobación del nuevo correo
      electrónico.
    MSG

    assert_text message
    assert_equal 'terec@example.com', User.first.email
    assert_equal 'terfo@example.com', User.first.unconfirmed_email
  end

  private

  def submit_form(username: nil, email: nil, password: nil)
    visit edit_user_registration_path

    fill_in('Nombre de usuario', with: username) if username
    fill_in('Correo electrónico', with: email) if email
    fill_in('Contraseña actual', with: password) if password

    click_button 'Guardar'
  end
end
