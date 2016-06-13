require "test_helper"
require "integration/concerns/authentication"

class MessagesTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers

  before do
    user1 = FactoryGirl.create(:user, username: 'user1')
    @user2 = FactoryGirl.create(:user, username: 'user2')

    login_as user1

    visit message_new_path(@user2)
  end

  it 'shows errors when message has no subject' do
    send_message('hola, user2')

    assert_content('Título no puede estar en blanco')
  end

  it 'shows the other user in the conversation header' do
    send_message('hola, user2', 'Cosas')
    assert_content('Conversación con user2')

    login_as @user2

    visit mailboxer_message_path(Mailboxer::Message.first)
    assert_content('Conversación con user1')
  end

  it "messages another user" do
    send_message("hola trololo", "hola mundo")

    assert_content("hola trololo")
    assert_content("Mover mensaje a papelera")
  end

  it "messages another user using emojis" do
    skip "emojis not supported"
    send_message("What a nice emoji😀!", "hola mundo")

    assert_content("What a nice emoji😀!")
    assert_content("Mover mensaje a papelera")
  end

  it "replies to a message" do
    send_message("hola trololo", "hola mundo")
    send_message("hola trululu")

    assert_content("hola trululu")
  end

  private

  def send_message(body, subject = nil)
    fill_in("mailboxer_message_subject", with: subject) if subject
    fill_in "mailboxer_message_body", with: body
    click_button "Enviar"
  end
end

