# frozen_string_literal: true
require 'integration/concerns/authentication'

module Messages
  include Warden::Test::Helpers

  def setup
    super

    user1 = FactoryGirl.create(:user, username: 'user1')
    @user2 = FactoryGirl.create(:user, username: 'user2')

    login_as user1

    visit message_new_path(@user2)
  end

  def test_shows_errors_when_message_has_no_subject
    send_message(body: 'hola, user2')

    assert_content('Título no puede estar en blanco')
  end

  def test_prevents_from_creating_conversation_with_empty_message
    send_message(subject: 'hola, user2')

    assert_content('Nuevo mensaje privado para el usuario user2')
  end

  def test_shows_errors_when_replying_to_conversation_with_empty_message
    send_message(subject: 'hola, user2', body: 'How you doing?')
    send_message(body: '')

    assert_content('Mensaje no puede estar en blanco')
  end

  def test_sends_a_new_message_after_a_previous_error
    send_message(body: 'hola, user2')
    send_message(subject: 'forgot the title', body: 'hola, user2')

    assert_content('Conversación con user2 asunto forgot the title')
  end

  def test_replies_to_conversation
    send_message(subject: 'hola, user2', body: 'How you doing?')
    send_message(body: 'hola, user1, nice to see you around')

    page.assert_selector '.bubble', text: 'nice to see you around'
  end

  def test_replies_to_conversation_after_a_previous_error
    send_message(subject: 'hola, user2', body: 'How you doing?')
    send_message(body: '')
    send_message(body: 'forgot to reply something')

    page.assert_selector '.bubble', text: 'forgot to reply something'
  end

  def test_shows_the_other_user_in_the_conversation_header
    send_message(subject: 'Cosas', body: 'hola, user2')
    assert_content('Conversación con user2')

    login_as @user2

    visit mailboxer_message_path(Mailboxer::Message.first)
    assert_content('Conversación con user1')
  end

  def test_links_to_the_other_user_in_the_conversation_list
    send_message(subject: 'Cosas', body: 'hola, user2')
    visit messages_list_path(box: 'sent')

    assert page.has_link?('user2'), 'No link to "user2" found'
  end

  def test_just_shows_a_special_label_when_the_interlocutor_is_no_longer_there
    send_message(subject: 'Cosas', body: 'hola, user2')
    @user2.destroy
    visit messages_list_path(box: 'sent')

    assert_content '[borrado]'
    refute page.has_link?('[borrado]')
  end

  def test_messages_another_user
    send_message(subject: 'hola mundo', body: 'hola trololo')

    assert_content('hola trololo')
    assert_content('Mover mensaje a papelera')
  end

  def test_messages_another_user_using_emojis
    skip 'emojis not supported'
    send_message(subject: 'hola mundo', body: 'What a nice emoji😀!')

    assert_content('What a nice emoji😀!')
    assert_content('Mover mensaje a papelera')
  end

  def test_replies_to_a_message
    send_message(subject: 'hola mundo', body: 'hola trololo')
    send_message(body: 'hola trululu')

    assert_content('hola trululu')
  end

  private

  def send_message(params)
    subject = params[:subject]

    fill_in('mailboxer_message_subject', with: subject) if subject
    fill_in 'mailboxer_message_body', with: params[:body]
    click_button 'Enviar'
  end
end
