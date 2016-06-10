require "test_helper"
require "integration/concerns/authentication"

class CanUserMessage < ActionDispatch::IntegrationTest
  include Authentication

  before do
    user1 = FactoryGirl.create(:user)
    user2 = FactoryGirl.create(:user)

    login_as user1

    visit message_new_path(user2)
  end

  it "should message another user" do
    send_message("hola trololo", "hola mundo")

    assert_content("hola trololo")
    assert_content("Mover mensaje a papelera")
  end

  it "should message another user using emojis" do
    skip "emojis not supported"
    send_message("What a nice emoji😀!", "hola mundo")

    assert_content("What a nice emoji😀!")
    assert_content("Mover mensaje a papelera")
  end

  it "should reply to a message" do
    send_message("hola trololo", "hola mundo")
    send_message("hola trululu")

    assert_content("hola trululu")
  end

  def send_message(body, subject = nil)
    fill_in("mailboxer_message_subject", with: subject) if subject
    fill_in "mailboxer_message_body", with: body
    click_button "Enviar"
  end
end

