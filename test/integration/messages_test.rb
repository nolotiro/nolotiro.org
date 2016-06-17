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
    send_message(body: 'hola, user2')

    assert_content('Título no puede estar en blanco')
  end

  it 'shows errors when creating conversation with empty message' do
    send_message(subject: 'hola, user2')

    assert_content('Mensaje no puede estar en blanco')
  end

   it 'shows errors when replying to conversation with empty message' do
    send_message(subject: 'hola, user2', body: 'How you doing?')
    send_message(body: '')

    assert_content('Mensaje no puede estar en blanco')
  end

  it 'sends a new message after a previous error' do
    send_message(body: 'hola, user2')
    send_message(subject: 'forgot the title', body: 'hola, user2')

    assert_content('Conversación con user2 asunto forgot the title')
  end

  it 'replies to conversation' do
    send_message(subject: 'hola, user2', body: 'How you doing?')
    send_message(body: 'hola, user1, nice to see you around')

    page.assert_selector '.bubble', text: 'nice to see you around'
  end

  it 'replies to conversation after a previous error' do
    send_message(subject: 'hola, user2', body: 'How you doing?')
    send_message(body: '')
    send_message(body: 'forgot to reply something')

    page.assert_selector '.bubble', text: 'forgot to reply something'
  end

  it 'shows the other user in the conversation header' do
    send_message(subject: 'Cosas', body: 'hola, user2')
    assert_content('Conversación con user2')

    login_as @user2

    visit mailboxer_message_path(Mailboxer::Message.first)
    assert_content('Conversación con user1')
  end

  it 'links to the other user in the conversation list' do
    send_message(subject: 'Cosas', body: 'hola, user2')
    visit messages_list_path(box: 'sent')

    assert page.has_link?('user2'), 'No link to "user2" found'
  end

  it 'just shows a special label when the interlocutor is no longer there' do
    send_message(subject: 'Cosas', body: 'hola, user2')
    @user2.destroy
    visit messages_list_path(box: 'sent')

    assert_content '[borrado]'
    refute page.has_link?('[borrado]')
  end

  it "messages another user" do
    send_message(subject: "hola mundo", body: "hola trololo")

    assert_content("hola trololo")
    assert_content("Mover mensaje a papelera")
  end

  it "messages another user using emojis" do
    skip "emojis not supported"
    send_message(subject: "hola mundo", body: "What a nice emoji😀!")

    assert_content("What a nice emoji😀!")
    assert_content("Mover mensaje a papelera")
  end

  it "replies to a message" do
    send_message(subject: "hola mundo", body: "hola trololo")
    send_message(body: "hola trululu")

    assert_content("hola trululu")
  end

  private

  def send_message(params)
    subject = params[:subject]

    fill_in("mailboxer_message_subject", with: subject) if subject
    fill_in "mailboxer_message_body", with: params[:body]
    click_button "Enviar"
  end
end

