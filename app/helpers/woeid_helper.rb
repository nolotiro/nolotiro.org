module WoeidHelper

  def self.convert_woeid_name woeid
    # get from cache 
    key = 'woeid_' + woeid.to_s
    if Rails.cache.fetch(key)
      return Rails.cache.fetch(key)
    else
      GeoPlanet.appid = APP_CONFIG[:geoplanet_app_id]
      place_raw = GeoPlanet::Place.new(woeid, :lang => :es)
      place = "#{place_raw.name}, #{place_raw.admin1}, #{place_raw.country}"
      Rails.cache.write(key, place)
      return place
    end
  end

end
