module WoeidHelper

  def self.convert_woeid_name woeid
    # search by woeid, return place 
    #
    # param woeid: integer. example: 244444
    # return place: string. format: "City, State, Country"
    #
    key = 'woeid_' + woeid.to_s
    if Rails.cache.fetch(key)
      return Rails.cache.fetch(key)
    else
      GeoPlanet.appid = APP_CONFIG["geoplanet_app_id"]
      place_raw = GeoPlanet::Place.new(woeid.to_i, :lang => :es)
      place = "#{place_raw.name}, #{place_raw.admin1}, #{place_raw.country}"
      Rails.cache.write(key, place)
      return place
    end
  end

  def self.search_by_name name
    # search by name, return possible places 
    #
    # param name: string. example: "Madrid"
    # return places: list. format: [["Madrid, Madrid, España",766273],["Madrid, Comunidad de Madrid, España",12578024],["Madrid, Cundinamarca, Colombia",361938]]
    #
    key = 'location_' + name
    if Rails.cache.fetch(key)
      return Rails.cache.fetch(key)
    else
      GeoPlanet.appid = APP_CONFIG["geoplanet_app_id"]
      # FIXME: this is really slow. optimize plz
      locations = GeoPlanet::Place.search(name, :lang => :es, :count => 0)
      places = []
      if locations.nil? 
        places = nil
      else
        locations.each do |l|
          places.append [WoeidHelper.convert_woeid_name(l.woeid), l.woeid] 
        end
      end
      Rails.cache.write(key, places)
      return places
    end
  end

end
