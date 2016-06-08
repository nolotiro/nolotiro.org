module OauthHelpers
  def mock_facebook(info)
    OmniAuth.config.mock_auth[:facebook] =
      OmniAuth::AuthHash.new(provider: 'facebook', uid: '1', info: info)
  end
end
