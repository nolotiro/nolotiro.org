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
end
