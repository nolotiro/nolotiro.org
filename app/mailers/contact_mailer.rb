# frozen_string_literal: true

class ContactMailer < ActionMailer::Base
  default to: ENV['NLT_DEFAULT_TO']

  def contact_form(email, message, request)
    @email = email
    @ip_address = request.remote_ip
    @ua = request.user_agent
    @message = message

    mail from: email, subject: "nolotiro.org - contact from #{email}"
  end
end
