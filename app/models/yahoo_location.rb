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

  def label
    "#{fullname} (#{I18n.t('nlt.ads.count', count: ads_count)})"
  end

  def woeid
    @place.woeid
  end

  def town?
    @place.placetype_code == 7
  end

  private

  def ads_count
    @ads_count ||= Ad.where(woeid_code: woeid).count
  end
end
