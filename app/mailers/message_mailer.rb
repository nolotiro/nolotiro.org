# frozen_string_literal: true

class MessageMailer < ActionMailer::Base
  default from: Rails.application.secrets.emails['default_from']

  def send_email(message, receiver)
    @message = message
    @receiver = receiver
    @subject = message.subject

    if message.conversation.messages.size > 1
      reply_message_email
    else
      new_message_email
    end
  end

  private

  def new_message_email
    mail to: @receiver.email,
         subject: t('mailboxer.message_mailer.subject_new', subject: @subject),
         template_name: 'new_message_email'
  end

  def reply_message_email
    mail to: @receiver.email,
         subject: t('mailboxer.message_mailer.subject_reply', subject: @subject),
         template_name: 'reply_message_email'
  end
end
