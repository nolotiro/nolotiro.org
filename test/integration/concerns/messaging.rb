# frozen_string_literal: true
module Messaging
  private

  def assert_message_sent(text)
    assert_css_selector '.bubble', text: text
    assert_content 'Mensaje enviado'
  end

  def send_message(params)
    subject = params[:subject]

    fill_in('message_subject', with: subject) if subject
    fill_in 'message_body', with: params[:body]
    click_button 'Enviar'
  end
end
