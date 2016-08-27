# frozen_string_literal: true
module WoeidHelper
  def self.convert_woeid_name(woeid)
    locale = I18n.locale
    key = 'woeid_' + locale.to_s + '_' + woeid.to_s
    value = Rails.cache.fetch(key)
    return value if value

    GeoPlanet.appid = Rails.application.secrets['geoplanet_app_id']
    begin
      place_raw = GeoPlanet::Place.new(woeid.to_i, lang: locale)
      place = YahooLocation.new(place_raw)

      return nil unless place.town?

      value = { full: place.fullname, short: place.name }
      Rails.cache.write(key, value)
      return value
    rescue GeoPlanet::NotFound
      return nil
    end
  end

  def self.search_by_name(name)
    return unless name

    GeoPlanet.appid = Rails.application.secrets['geoplanet_app_id']
    raw_locations = GeoPlanet::Place.search(name, lang: I18n.locale, type: 7, count: 0)
    return if raw_locations.nil?

    YahooResultSet.new(raw_locations)
  end
end
