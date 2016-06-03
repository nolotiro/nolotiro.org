class CallbacksController < Devise::OmniauthCallbacksController

  def facebook
    if oauth.info.email.nil?
      redirect_to new_user_registration_path(username: oauth.info.name),
                  alert: I18n.t('devise.failure.not_facebook_confirmed_email')
    else
      user = User.from_omniauth(oauth)
      sign_in user
      redirect_to root_url
    end
  end

  def google_oauth2
    user = User.from_omniauth(oauth)
    sign_in user
    redirect_to root_url
  end

  private

  def oauth
    request.env["omniauth.auth"]
  end
end
