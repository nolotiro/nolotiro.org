# frozen_string_literal: true

class UserMailer < ActionMailer::Base
  default from: Rails.application.secrets.emails['default_from']

  def confirmation_reminder(resource)
    @resource = resource
    mail(
      to: @resource.email,
      subject: '[nolotiro.org] Falta que confirmes tu cuenta'
    )
  end
end
