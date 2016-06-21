# encoding : utf-8
module GeoHelper

  def self.get_ip_address request
    debug_ip_address = Rails.application.secrets["debug_ip_address"]
    return debug_ip_address if debug_ip_address.present?

    ip_via_proxy = request.env['HTTP_X_FORWARDED_FOR']
    return ip_via_proxy.split(',')[0] if ip_via_proxy

    request.remote_ip
  end

  def self.suggest ip_address
    return unless ip_address

    db = MaxMindDB.new(Rails.root.to_s + '/vendor/geolite/GeoLite2-City.mmdb')
    suggestion = db.lookup(ip_address)
    # FIXME: use other APIs when there isn't an IP address mapped
    return unless suggestion.found?

    city = suggestion.city
    city_name = city.name(I18n.locale) || city.name('en')
    return unless city_name

    region = suggestion.subdivisions[0]
    region_name = region ? (region.name(I18n.locale) || region.name('en')) : ''

    country = suggestion.country
    country_name = country.name(I18n.locale) || country.name('en')

    "#{city_name}, #{region_name}, #{country_name}"
  end

end
