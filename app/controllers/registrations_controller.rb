class RegistrationsController < Devise::RegistrationsController
  def create
    if verify_recaptcha
      super
      if resource.save
        # Generate Analytics event
        AnalyticsWorker.perform_async resource.id, 'user_created'
      end
    else
      build_resource
      clean_up_passwords(resource)
      flash.now[:alert] = "Hubo un error rellenando los carácteres. Inténtalo de nuevo."
      flash.delete :recaptcha_error
      render :new
    end
  end

  def destroy
    # Generate Analytics event
    AnalyticsWorker.perform_async resource.id, 'user_destroyed', {'username' => resource.username }
    super
  end
end
