class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_locale
   
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
    ip_address = Rails.env == "development" ? "87.218.80.79" : request.remote_ip
    if request.env['HTTP_X_FORWARDED_FOR']
      ip_address = request.env['HTTP_X_FORWARDED_FOR'].split(',')[0] || ip_address
    end
    GeoHelper.suggest ip_address
  end

end
