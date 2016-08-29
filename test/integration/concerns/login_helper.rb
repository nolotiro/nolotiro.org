# frozen_string_literal: true
module LoginHelper
  include Warden::Test::Helpers

  def login(username, password)
    visit new_user_session_path
    fill_in 'user_email', with: username
    fill_in 'user_password', with: password
    click_button 'Acceder'
  end
end
