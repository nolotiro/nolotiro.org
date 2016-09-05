# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController
  def create
    if omniauth_registration? || verify_recaptcha
      super
    else
      build_resource
      clean_up_passwords(resource)
      flash.now[:alert] = flash[:recaptcha_error]
      flash.delete :recaptcha_error
      render :new
    end
  end

  protected

  def after_update_path_for(resource)
    profile_path(resource)
  end

  private

  def omniauth_registration?
    session['devise.omniauth_data']
  end

  helper_method :omniauth_registration?

  def omniauth_email?
    omniauth_registration? && session['devise.omniauth_data']['info']['email']
  end

  helper_method :omniauth_email?
end
