class RegistrationsController < Devise::RegistrationsController
  def create
    if verify_recaptcha
      super
    else
      build_resource
      clean_up_passwords(resource)
      flash.now[:alert] = flash[:recaptcha_error]
      flash.delete :recaptcha_error
      render :new
    end
  end
end
