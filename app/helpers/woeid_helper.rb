module WoeidHelper

  def self.convert_woeid_name woeid
    # search by woeid, return place
    #
    # param woeid: integer. example: 244444
    # return place: string. format: "City, State, Country"
    #

    locale = I18n.locale;
    key = 'woeid_' + locale.to_s + '_' + woeid.to_s
    if Rails.cache.fetch(key)
      return Rails.cache.fetch(key)
    else
      GeoPlanet.appid = Rails.application.secrets["geoplanet_app_id"]
      begin
          place_raw = GeoPlanet::Place.new(woeid.to_i, :lang => locale)
          place = YahooLocation.new(place_raw)

          if place.town?
                value = { full: place.fullname , short: place.name }
                Rails.cache.write(key, value)
                return value
          else
            return nil
          end
      rescue GeoPlanet::NotFound
        return nil
      end
    end
  end

  def self.search_by_name name
    # search by name, return possible places
    #
    # param name: string. example: "Madrid"
    # return places: list. format: [[full name, woeid, ad_count], ...]
    #                      example: [["Madrid, Madrid, España (2444 anuncios)",766273],["Madrid, Comunidad de Madrid, España (444 anuncios)",12578024],["Madrid, Cundinamarca, Colombia (0 anuncios)",361938]]
    #

    if name
      GeoPlanet.appid = Rails.application.secrets["geoplanet_app_id"]
      raw_locations = GeoPlanet::Place.search(name, :lang => I18n.locale, :type => 7, :count => 0)
      return if raw_locations.nil?

      raw_locations.map { |raw_location| YahooLocation.new(raw_location) }
    else
      nil
    end
  end

end
