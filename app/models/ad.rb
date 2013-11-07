class Ad < ActiveRecord::Base

  require 'geoplanet'

  class << self
 
    def search_by_woeid woeid
      GeoPlanet.appid = APP_CONFIG[:geoplanet_app_id]
      GeoPlanet::Place.new(woeid)
    end

    def filter_by_woeid woeid
      GeoPlanet.appid = APP_CONFIG[:geoplanet_app_id]
      Ad.find_by_woeid_code(GeoPlanet::Place.new(woeid))
    end

  end

end
