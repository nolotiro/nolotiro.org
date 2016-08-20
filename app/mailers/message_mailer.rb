# frozen_string_literal: true

class MessageMailer < ActionMailer::Base
  default from: Rails.application.secrets.emails['default_from']

  def send_email(message)
    @message = message
    @receiver = message.recipient
    @subject = message.subject

    mail to: @receiver.email,
         subject: t('mailboxer.message_mailer.subject_new', subject: @subject),
         template_name: 'new_message_email'
  end
end
