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

  private

  def omniauth_registration?
    session['devise.omniauth_data']
  end

  helper_method :omniauth_registration?
end
