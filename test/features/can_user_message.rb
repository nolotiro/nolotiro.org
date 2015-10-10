require "test_helper"
include Warden::Test::Helpers

feature "CanUserMessage" do

  scenario "should message another user", js: true do

    @user1 = FactoryGirl.create(:user)
    @user2 = FactoryGirl.create(:user)

    login_as @user1

    visit message_new_path(@user2)
    body = "hola trololo"
    fill_in "mailboxer_message_subject", with: "hola mundo"
    fill_in "mailboxer_message_body", with: body
    click_button "Enviar"
    page.must_have_content body
    page.must_have_content "Mover mensaje a papelera"

    reply = "What a nice emoji😀!What a nice emoji😀!What a nice emoji😀!What a nice emoji😀!What a nice emoji😀!"
    fill_in "mailboxer_message_body", with: reply
    click_button "Enviar"
    save_and_open_page
    page.must_have_content reply
  end

end

