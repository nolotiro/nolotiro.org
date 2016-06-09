class CallbacksController < Devise::OmniauthCallbacksController

  def facebook
    if oauth_user
      sign_in_and_redirect
    else
      session['devise.omniauth_data'] = oauth
      redirect_to new_user_registration_path
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
    @oauth_user ||= OauthenticatorService.new(oauth).authenticate
  end

  def oauth
    request.env["omniauth.auth"]
  end
end
