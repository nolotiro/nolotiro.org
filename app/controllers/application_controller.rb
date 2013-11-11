class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  def get_location_suggest 
    ip_address = Rails.env == "development" ? "87.218.80.79" : request.remote_ip
    GeoHelper.suggest ip_address
  end

end
