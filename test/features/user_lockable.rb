require "test_helper"
include Warden::Test::Helpers

feature "UserLockable" do

  scenario "should lock after 10 tries on user", js: true do

    @user = FactoryGirl.create(:user)

    (1..10).each do |n|
      visit new_user_session_path
      fill_in "user_email", with: @user.email
      fill_in "user_password", with: "trololololo" 
      click_button "Acceder"
      page.must_have_content I18n.t('devise.failure.not_found_in_database')
    end

    visit new_user_session_path
    fill_in "user_email", with: @user.email
    fill_in "user_password", with: "trololololo" 
    click_button "Acceder"
    save_and_open_page
    page.must_have_content "Bloqueado"

  end

end
