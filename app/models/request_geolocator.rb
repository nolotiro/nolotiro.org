# frozen_string_literal: true

class RequestGeolocator
  def initialize(ip)
    @ip = ip
  end

  def suggest
    return unless @ip

    db = MaxMindDB.new(Rails.root.to_s + '/vendor/geolite/GeoLite2-City.mmdb')
    suggestion = db.lookup(@ip)

    # FIXME: use other APIs when there isn't an IP address mapped
    return unless suggestion.found?

    location = MaxMind::Location.new(suggestion)
    return unless location.city

    location
  end
end
