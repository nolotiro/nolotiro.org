class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_locale

  # after a user sing ins, go to their location
  def after_sign_in_path_for(resource)
    if current_user.woeid?
      woeid_path(current_user.woeid)
    # or ask for the location
    else
      location_ask_path
    end
  end
   
  def set_locale
      I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options(options={})
    #logger.debug "default_url_options is passed options: #{options.inspect}\n"
    { locale: I18n.locale }
  end

  private

  def get_section_locations
    key = 'section_locations'
    if Rails.cache.fetch(key)
      @section_locations = Rails.cache.fetch(key)
    else
      locations = []
      Ad.available.find(:all).group_by(&:woeid_code).each do |woeid_code, ad| 
        locations.append [woeid_code,ad.count]
      end
      @section_locations = locations.sort {|a,b| b[1] <=> a[1]}
      Rails.cache.write(key, @locations)
    end
  end

  def get_location_suggest 
    ip_address = GeoHelper.get_ip_address request
    GeoHelper.suggest ip_address
  end

end
