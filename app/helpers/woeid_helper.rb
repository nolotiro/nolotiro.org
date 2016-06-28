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

    locale = I18n.locale;
    if name
      key = 'location_' + locale.to_s + '_' + name
      if Rails.cache.fetch(key)
        return Rails.cache.fetch(key)
      else
        GeoPlanet.appid = Rails.application.secrets["geoplanet_app_id"]
        locations = GeoPlanet::Place.search(name, :lang => locale, :type => 7, :count => 0)
        return if locations.nil?

        places = locations.map do |l|
          l = YahooLocation.new(l)
          name = l.fullname
          count = I18n.t('nlt.ads.count', count: l.ads_count)

          ["#{name} (#{count})", l.woeid]
        end
        Rails.cache.write(key, places)
        return places
      end
    else
      nil
    end
  end

end
