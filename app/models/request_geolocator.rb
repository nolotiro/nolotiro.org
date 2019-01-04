# frozen_string_literal: true

class RequestGeolocator
  def initialize(ip)
    @ip = ip
  end

  def suggest
    return unless @ip

    db = MaxMindDB.new(Rails.root.to_s + "/vendor/geolite/GeoLite2-City.mmdb")
    suggestion = db.lookup(@ip)

    # FIXME: use other APIs when there isn't an IP address mapped
    return unless suggestion.found? && suggestion.city

    geoname_id = suggestion.city&.geoname_id
    return unless geoname_id

    Town.includes(:state, :country).find_by(geoname_id: geoname_id)
  end
end
