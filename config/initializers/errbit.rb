# frozen_string_literal: true

if Rails.env.production? || Rails.env.staging?
  Airbrake.configure do |config|
    config.project_key = ENV['AIRBRAKE_APIKEY']
    config.project_id = 1
    config.host = ENV['AIRBRAKE_HOST']
  end
end
