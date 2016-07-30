# encoding : utf-8
# frozen_string_literal: true
class RequestGeolocator
  def initialize(request)
    @request = request
  end

  def ip_address
    debug_ip_address = Rails.application.secrets['debug_ip_address']
    return debug_ip_address if debug_ip_address.present?

    @request.remote_ip
  end

  def suggest
    return unless ip_address

    db = MaxMindDB.new(Rails.root.to_s + '/vendor/geolite/GeoLite2-City.mmdb')
    suggestion = db.lookup(ip_address)
    # FIXME: use other APIs when there isn't an IP address mapped
    return unless suggestion.found?

    location = MaxMindLocation.new(suggestion)
    return unless location.city

    location
  end
end
