# frozen_string_literal: true
require 'test_helper'
require 'support/web_mocking'

class PasswordResetTest < ActionDispatch::IntegrationTest
  include WebMocking

  before { @user = create(:user, email: 'nolotiro@example.com') }

  it 'sends a confirmation email' do
    visit root_path
    click_link 'acceder'
    click_link '¿Has olvidado tu contraseña?'
    fill_in 'Correo electrónico', with: 'nolotiro@example.com'
    click_button 'Enviar por correo'

    assert_text <<~MSG
      Vas a recibir un correo con instrucciones sobre cómo resetear tu
      contraseña en unos pocos minutos.
    MSG
  end

  it 'changes password and logs user in' do
    mocking_yahoo_woeid_info(@user.woeid) do
      token = @user.send_reset_password_instructions
      visit edit_user_password_path(reset_password_token: token)

      fill_in 'Contraseña nueva', with: '222222'
      fill_in 'Contraseña nueva (repetir)', with: '222222'
      click_button 'Cambiar contraseña'

      assert_text 'Tu contraseña fue cambiada. Ya iniciaste sesión.'
    end
  end
end
