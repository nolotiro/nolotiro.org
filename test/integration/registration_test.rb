# frozen_string_literal: true

require 'test_helper'
require 'integration/concerns/login_helper'

class RegistrationTest < ActionDispatch::IntegrationTest
  include LoginHelper

  before do
    visit root_path
    click_link 'nuevo usuario'
  end

  it 'sends a confirmation email' do
    fill_registration_form(email: 'nolotiro@example.com')
    click_button 'Regístrate'

    assert_text <<~MSG
      Se ha enviado un mensaje con un enlace de confirmación a tu correo
      electrónico.
    MSG
  end

  it 'redirects to change city page after first login' do
    fill_registration_form(email: 'nolotiro@example.com', password: '222222')
    click_button 'Regístrate'
    User.first.confirm
    login('nolotiro@example.com', '222222')

    assert_text 'Cambia tu ciudad'
  end

  it 'allows login after registration' do
    fill_registration_form(email: 'n.o.l.o.tiro@gmail.com', password: '333333')
    click_button 'Regístrate'
    User.first.confirm
    login('n.o.l.o.tiro@gmail.com', '333333')

    assert_text 'Has iniciado sesión'
  end

  it 'automatically bans users registering from recently banned ips' do
    fill_registration_form(email: 'nolotiro@example.com')
    create(:user, :recent_spammer, last_sign_in_ip: '1.1.1.1')
    page.driver.options[:headers] = { 'REMOTE_ADDR' => '1.1.1.1' }

    click_button 'Regístrate'
    assert_equal 2, User.count
    refute_nil User.last.banned_at
    assert_equal '1.1.1.1', User.last.last_sign_in_ip
  end

  private

  def fill_registration_form(email:, password: '111111', username: 'nolotiro')
    fill_in 'Tu email', with: email
    fill_in 'Elige tu contraseña', with: password
    fill_in 'Introduce tu contraseña', with: password
    fill_in 'Elige un nombre de usuario', with: username
  end
end
