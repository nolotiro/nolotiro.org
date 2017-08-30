# frozen_string_literal: true

module Messaging
  private

  def assert_message_sent(text)
    assert_selector '.bubble', text: text
    assert_text 'Mensaje enviado'
  end

  def send_message(body: nil, subject: nil)
    fill_in('subject', with: subject) if subject
    fill_in 'body', with: body
    click_button 'Enviar'
  end

  def go_to_conversation_as(conversation, user)
    relogin_as user
    visit conversation_path(conversation)
  end

  def assert_shows_special_label_for_deleted_user
    visit conversations_path
    assert_text '[borrado]'
    assert_no_selector 'a', text: '[borrado]'

    visit conversation_path(Conversation.first)
    assert_text '[borrado]'
    assert_no_selector 'a', text: '[borrado]'
  end
end
