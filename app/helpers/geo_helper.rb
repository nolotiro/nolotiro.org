# encoding : utf-8
module GeoHelper

  def self.get_ip_address request
    ip_address = Rails.env == "development" ? "87.218.80.79" : request.remote_ip
    if request.env['HTTP_X_FORWARDED_FOR']
      ip_address = request.env['HTTP_X_FORWARDED_FOR'].split(',')[0] || ip_address
    end
    ip_address
  end

  def self.suggest ip_address
    c = GeoIP.new(Rails.root.to_s + '/vendor/geolite/GeoLiteCity.dat').country(ip_address)
    # cutre translator from Spain to España
    country = c.country_name == "Spain" ? "España" : c.country_name
    "#{c.city_name}, #{c.real_region_name}, #{country}".force_encoding('utf-8')
  end

end
