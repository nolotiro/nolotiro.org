# frozen_string_literal: true

require 'test_helper'

class ProfileEditionAndRemovalTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers

  before do
    user = create(:user, username: 'teresa_electricista',
                         password: 'topsecret',
                         email: 'terec@example.com')
    login_as(user)

    visit profile_path(user.username)

    click_link 'editar perfil de usuario'
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

  it 'allows account deletion' do
    click_link 'Cancelar mi cuenta'

    assert_text 'Fue grato tenerte con nosotros. Tu cuenta fue cancelada.'
  end

  private

  def submit_form(username: nil, email: nil, password: nil)
    fill_in('Nombre de usuario', with: username) if username
    fill_in('Correo electrónico', with: email) if email
    fill_in('Contraseña actual', with: password) if password

    click_button 'Guardar'
  end
end
