class CallbacksController < Devise::OmniauthCallbacksController

  def facebook
    if oauth.info.email
      sign_in_and_redirect
    else
      redirect_to new_user_registration_path(username: oauth.info.name),
                  alert: I18n.t('devise.failure.not_facebook_confirmed_email')
    end
  end

  def google_oauth2
    sign_in_and_redirect
  end

  private

  def sign_in_and_redirect
    sign_in oauth_user
    redirect_to root_url
  end

  def oauth_user
    @oauth_user ||= User.from_omniauth(oauth)
  end

  def oauth
    request.env["omniauth.auth"]
  end
end
