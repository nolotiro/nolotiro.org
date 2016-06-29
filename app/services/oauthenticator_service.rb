#
# Authenticates a user given the Oauth hash
#
class OauthenticatorService
  def initialize(oauth)
    @oauth = oauth
  end

  def authenticate
    identity = Identity.find_by(provider: provider, uid: uid)
    return identity.user if identity

    return unless email

    user = User.find_or_initialize_by(email: email) do |u|
      u.username = username
      u.confirmed_at = Time.zone.now
    end

    user.identities.build(provider: provider, uid: uid)
    user.save!
    user
  end

  private

  def provider
    @oauth.provider
  end

  def uid
    @oauth.uid
  end

  def email
    @oauth.info.email
  end

  def username
    @oauth.info.name
  end
end
