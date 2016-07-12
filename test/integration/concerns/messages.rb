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

    assert_content 'Título no puede estar en blanco'
  end

  def test_prevents_from_creating_conversation_with_empty_message
    send_message(subject: 'hola, user2')

    assert_content 'Nuevo mensaje privado para el usuario user2'
  end

  def test_shows_errors_when_replying_to_conversation_with_empty_message
    send_message(subject: 'hola, user2', body: 'How you doing?')
    send_message(body: '')

    assert_content 'Mensaje no puede estar en blanco'
  end

  def test_sends_a_new_message_after_a_previous_error
    send_message(body: 'hola, user2')
    send_message(subject: 'forgot the title', body: 'hola, user2')

    assert_message_sent 'hola, user2'
  end

  def test_replies_to_conversation
    send_message(subject: 'hola, user2', body: 'How you doing?')
    send_message(body: 'hola, user1, nice to see you around')

    assert_message_sent 'nice to see you around'
  end

  def test_replies_to_conversation_after_a_previous_error
    send_message(subject: 'hola, user2', body: 'How you doing?')
    send_message(body: '')
    send_message(body: 'forgot to reply something')

    assert_message_sent 'forgot to reply something'
  end

  def test_shows_the_other_user_in_the_conversation_header
    send_message(subject: 'Cosas', body: 'hola, user2')
    assert_content 'Conversación con user2'

    login_as @user2

    visit mailboxer_conversation_path(Mailboxer::Conversation.first)
    assert_content 'Conversación con user1'
  end

  def test_links_to_the_other_user_in_the_conversation_list
    send_message(subject: 'Cosas', body: 'hola, user2')
    visit messages_list_path

    assert page.has_link?('user2'), 'No link to "user2" found'
  end

  def test_just_shows_a_special_label_when_the_interlocutor_is_no_longer_there
    send_message(subject: 'Cosas', body: 'hola, user2')
    @user2.destroy
    visit messages_list_path

    assert_content '[borrado]'
    refute page.has_link?('[borrado]')
  end

  def test_messages_another_user
    send_message(subject: 'hola mundo', body: 'hola trololo')

    assert_message_sent 'hola trololo'
    assert_content 'Borrar mensaje'
  end

  def test_deletes_a_single_message_and_shows_an_confirmation_flash
    send_message(subject: 'hola mundo', body: 'What a nice message!')
    click_link 'Borrar mensaje'

    refute_content 'hola mundo'
    assert_content 'Mensaje borrado'
  end

  def test_deletes_multiple_messages_by_checkbox
    send_message(subject: 'hola mundo', body: 'What a nice message!')
    visit message_new_path(@user2)
    send_message(subject: 'hola marte', body: 'What a nice message!')

    visit messages_list_path
    check("delete-conversation-#{Mailboxer::Conversation.first.id}")
    dismiss_cookie_bar
    click_button 'Borrar mensajes seleccionados'

    refute_content 'hola mundo'
    assert_content 'hola marte'
  end

  private

  def assert_message_sent(text)
    assert_css_selector '.bubble', text: text
    assert_content 'Mensaje enviado'
  end

  #
  # Sometimes cookie bar gets in the middle of our tests.
  # Just dismiss the alert for now.
  #
  def dismiss_cookie_bar
    within('#cookie-bar') { click_link 'OK' }
  end

  def send_message(params)
    subject = params[:subject]

    fill_in('mailboxer_message_subject', with: subject) if subject
    fill_in 'mailboxer_message_body', with: params[:body]
    click_button 'Enviar'
  end
end
