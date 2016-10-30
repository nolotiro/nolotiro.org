# frozen_string_literal: true

require 'test_helper'
require 'integration/concerns/login_helper'

class RegistrationTest < ActionDispatch::IntegrationTest
  include LoginHelper

  before do
    visit root_path
    click_link 'nuevo usuario'
    fill_in 'Tu email', with: 'nolotiro@example.com'
    fill_in 'Elige tu contraseña', with: '111111'
    fill_in 'Introduce tu contraseña', with: '111111'
    fill_in 'Elige un nombre de usuario', with: 'nolotiro'
  end

  it 'sends a confirmation email' do
    click_button 'Regístrate'

    assert_text <<~MSG
      Se ha enviado un mensaje con un enlace de confirmación a tu correo
      electrónico.
    MSG
  end

  it 'redirects to change city page after first login' do
    click_button 'Regístrate'
    User.first.confirm
    login('nolotiro@example.com', '111111')

    assert_text 'Cambia tu ciudad'
  end

  it 'automatically bans users registering from recently banned ips' do
    create(:user, :recent_spammer, last_sign_in_ip: '1.1.1.1')
    page.driver.options[:headers] = { 'REMOTE_ADDR' => '1.1.1.1' }

    click_button 'Regístrate'
    assert_equal 2, User.count
    refute_nil User.last.banned_at
  end
end
