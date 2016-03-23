require "test_helper"
include Warden::Test::Helpers

feature "CanUserMessage" do

  scenario "should message another user", js: true do

    @user1 = FactoryGirl.create(:user)
    @user2 = FactoryGirl.create(:user)

    login_as @user1

    visit message_new_path(@user2)

    send_message("hola trololo", "hola mundo")
    page.must_have_content body
    page.must_have_content "Mover mensaje a papelera"

    send_message("What a nice emoji😀!")
    page.must_have_content reply
  end

  def send_message(body, subject = nil)
    fill_in("mailboxer_message_subject", with: subject) if subject
    fill_in "mailboxer_message_body", with: body
    click_button "Enviar"
  end
end

