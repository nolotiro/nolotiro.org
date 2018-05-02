# frozen_string_literal: true

require "test_helper"

class RequestGeolocatorTest < ActionView::TestCase
  it "suggests location from ip address" do
    suggestion = RequestGeolocator.new("74.125.225.224").suggest

    assert_equal "Alameda, California, Estados Unidos",
                 suggestion.fullname
  end

  it "suggests properly translated locations" do
    I18n.with_locale(:en) do
      suggestion = RequestGeolocator.new("74.125.225.224").suggest
      assert_equal "Alameda, California, United States", suggestion.fullname
    end
  end

  it "does not suggest a location unless it's city-specific" do
    assert_nil \
      RequestGeolocator.new(ip_from_brazil_but_not_a_specific_city).suggest
  end

  private

  def ip_from_brazil_but_not_a_specific_city
    "177.20.105.105"
  end
end
