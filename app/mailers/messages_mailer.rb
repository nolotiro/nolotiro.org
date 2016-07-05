# frozen_string_literal: true
class MessagesMailer < ActionMailer::Base
  default from: Rails.application.secrets.emails['default_from']

  def create(to_email, from_username, subject, message)
    @from_username = from_username
    @subject = subject
    @message = message
    mail(
      to: to_email,
      subject: "[nolotiro.org] Tienes un nuevo mensaje del usuario #{@from_username}"
    )
  end

end
