Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, Rails.application.secrets.omniauth["facebook"]["app_id"],  Rails.application.secrets.omniauth["facebook"]["app_secret"], scope: 'email', info_fields: 'name,email'
  provider :google_oauth2, Rails.application.secrets.omniauth["google"]["client_id"],  Rails.application.secrets.omniauth["google"]["client_secret"]
end
