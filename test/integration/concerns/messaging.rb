# frozen_string_literal: true
module Messaging
  private

  def assert_message_sent(text)
    assert_css_selector '.bubble', text: text
    assert_text 'Mensaje enviado'
  end

  def send_message(body: nil, subject: nil)
    fill_in('subject', with: subject) if subject
    fill_in 'body', with: body
    click_button 'Enviar'
  end
end
