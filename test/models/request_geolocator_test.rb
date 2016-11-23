# frozen_string_literal: true

require 'test_helper'

class RequestGeolocatorTest < ActionView::TestCase
  test 'does not suggest location from IP address if city not in DB' do
    assert_nil RequestGeolocator.new(ip_in_madrid).suggest
  end

  test 'does not suggest location from IP address if geoname_id not in DB' do
    create(:town, :madrid, geoname_id: nil)

    assert_nil RequestGeolocator.new(ip_in_madrid).suggest
  end

  test 'suggests location from IP address if city and geoname_id are in DB' do
    create(:town, :madrid)

    assert_equal 'Madrid, Comunidad de Madrid, España',
                 RequestGeolocator.new(ip_in_madrid).suggest.fullname
  end

  test "does not suggests a location unless it's city-specific" do
    assert_nil \
      RequestGeolocator.new(ip_from_brazil_but_not_a_specific_city).suggest
  end

  private

  def ip_in_madrid
    '83.39.207.18'
  end

  def ip_from_brazil_but_not_a_specific_city
    '179.168.191.163'
  end
end
