#
# Wraper around GeoPlanet::Place
#
class YahooLocation
  def initialize(place)
    @place = place
  end

  def fullname
    "#{@place.name}, #{@place.admin1}, #{@place.country}"
  end

  def name
    @place.name
  end

  def ads_count
    Ad.where(woeid_code: woeid).count
  end

  def woeid
    @place.woeid
  end

  def town?
    @place.placetype_code == 7
  end
end
