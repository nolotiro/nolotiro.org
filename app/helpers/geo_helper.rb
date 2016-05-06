# encoding : utf-8
module GeoHelper

  def self.get_ip_address request
    ip_address = Rails.application.secrets["debug_ip_address"] != ""  ? Rails.application.secrets["debug_ip_address"] : request.remote_ip
    if request.env['HTTP_X_FORWARDED_FOR']
      ip_address = request.env['HTTP_X_FORWARDED_FOR'].split(',')[0] || ip_address
    end
    ip_address
  end

  def self.suggest ip_address
    return unless ip_address

    db = MaxMindDB.new(Rails.root.to_s + '/vendor/geolite/GeoLite2-City.mmdb')
    suggestion = db.lookup(ip_address)
    # FIXME: use other APIs when there isn't an IP address mapped
    return "Madrid, Madrid, España" unless suggestion.found?

    city = suggestion.city
    city_name = city.name(I18n.locale) || city.name('en')

    region = suggestion.subdivisions[0]
    region_name = region ? (region.name(I18n.locale) || region.name('en')) : ''

    country = suggestion.country
    country_name = country.name(I18n.locale) || country.name('en')

    "#{city_name}, #{region_name}, #{country_name}"
  end

end
