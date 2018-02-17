# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook,
           ENV["FACEBOOK_APP_ID"],
           ENV["FACEBOOK_APP_SECRET"],
           scope: "email",
           info_fields: "name,email"

  provider :google_oauth2,
           ENV["GOOGLE_CLIENT_ID"],
           ENV["GOOGLE_CLIENT_SECRET"],
           name: "google",
           skip_jwt: true
end
