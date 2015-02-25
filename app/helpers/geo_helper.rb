# encoding : utf-8
module GeoHelper

  def self.get_ip_address request
    ip_address = APP_CONFIG["debug_ip_address"] != ""  ? APP_CONFIG["debug_ip_address"] : request.remote_ip
    if request.env['HTTP_X_FORWARDED_FOR']
      ip_address = request.env['HTTP_X_FORWARDED_FOR'].split(',')[0] || ip_address
    end
    ip_address
  end

  def self.suggest ip_address
    c = GeoIP.new(Rails.root.to_s + '/vendor/geolite/GeoLiteCity.dat').country(ip_address)
    # cutre translator from Spain to España
    "#{c.city_name}, #{c.real_region_name}, #{c.country_name}".force_encoding("ISO-8859-1").encode("UTF-8").gsub("Spain", "España")
  end

end
