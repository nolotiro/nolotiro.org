module OauthHelpers
  def login_via_facebook(attrs)
    OmniAuth.config.test_mode = true
    mock_facebook(attrs)
    visit user_omniauth_authorize_path(provider: 'facebook')
  end

  private

  def mock_facebook(info)
    OmniAuth.config.mock_auth[:facebook] =
      OmniAuth::AuthHash.new(provider: 'facebook', uid: '1', info: info)
  end
end
