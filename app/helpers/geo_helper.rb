# encoding : utf-8
module GeoHelper

   def self.suggest ip_address
     c = GeoIP.new('vendor/geolite/GeoLiteCity.dat').country(ip_address)
     # cutre translator from Spain to España
     country = c.country_name == "Spain" ? "España" : c.country_name
     "#{c.city_name}, #{c.real_region_name}, #{country}".force_encoding('utf-8')
   end

end
