require 'concerns/yahoo_location'

#
# Finds a proper "town" woeid for a user
#
# @note: assumes ads all have town woeids
#
class WoeidInferer
  def initialize(user)
    @user = user
  end

  def run
    place.ancestor_town || last_ad_woeid || place.descendant_town || 766_273
  end

  private

  def last_ad_woeid
    ads = @user.ads
    return unless ads.any?

    ads.order(published_at: :asc).last.woeid_code
  end

  def place
    @place ||= YahooLocation.new(@user.woeid)
  end
end
