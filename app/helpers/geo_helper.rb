# encoding : utf-8
module GeoHelper

   def self.suggest ip_address
     c = GeoIP.new('vendor/geolite/GeoLiteCity.dat').country(ip_address)
     # cutre translator from Spain to España
     case c.country_name
     when "Spain"
       country = "España"
     else
       country = c.country_name
     end
     "#{c.city_name}, #{c.real_region_name}, #{country}".force_encoding('utf-8')
   end

end
