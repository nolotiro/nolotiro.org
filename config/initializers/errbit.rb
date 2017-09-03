# frozen_string_literal: true

if Rails.env.production? || Rails.env.staging?
  Airbrake.configure do |config|
    config.project_key = ENV['AIRBRAKE_APIKEY']
    config.project_id = 1
    config.host = ENV['AIRBRAKE_HOST']
  end

  Airbrake.add_filter do |notice|
    allowed_errors = %w[ActiveRecord::RecordNotFound ActionController::RoutingError]

    if notice[:errors].any? { |error| allowed_errors.include?(error[:type]) }
      notice.ignore!
    end
  end
end
