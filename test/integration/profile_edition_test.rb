# frozen_string_literal: true
require 'test_helper'

require 'integration/concerns/authentication'

class ProfileEditionTest < ActionDispatch::IntegrationTest
  include Authentication

  before do
    user = create(:user, username: 'teresa_electricista', password: 'topsecret')
    login_as(user)
    visit edit_user_registration_path
    fill_in 'Nombre de usuario', with: 'teresa_fontanera'
    fill_in 'Contraseña actual', with: 'topsecret'
    click_button 'Guardar'
  end

  it 'allows changing the username' do
    assert_content 'Tu cuenta fue actualizada'
    assert_equal 'teresa_fontanera', User.first.username
  end
end
