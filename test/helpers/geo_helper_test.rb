require 'test_helper'

class GeoHelperTest < ActionView::TestCase
  include GeoHelper

  test "extracts ip address from request headers" do
    @request.headers["REMOTE_ADDR"] = "87.223.138.147"
    ip = GeoHelper.get_ip_address(@request)

    assert_equal("87.223.138.147", ip)
  end 

  test "suggests location from ip address" do
    suggestion = GeoHelper.suggest "8.8.8.8"
    assert_equal("Mountain View, California, Estados Unidos", suggestion)
  end

  test "suggests properly translated locations" do
    I18n.locale = :en
    suggestion = GeoHelper.suggest "8.8.8.8"
    assert_equal("Mountain View, California, United States", suggestion)
    I18n.locale = :es
  end

  test "does not suggests a location unless it's city-specific" do
    # This ip address is correctly resolved to Brazil, but not a specific city
    assert_nil GeoHelper.suggest "186.237.37.253"
  end
end
