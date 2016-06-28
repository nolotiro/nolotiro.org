require 'test_helper'

class GeoHelperTest < ActionView::TestCase
  include GeoHelper

  test "extracts ip address from request headers" do
    @request.headers["REMOTE_ADDR"] = "87.223.138.147"
    ip = GeoHelper.get_ip_address(@request)

    assert_equal("87.223.138.147", ip)
  end 

  test "suggests location from ip address" do
    @request.headers["REMOTE_ADDR"] = "8.8.8.8"
    suggestion = GeoHelper.suggest @request

    assert_equal("Mountain View, California, Estados Unidos", suggestion)
  end

  test "suggests properly translated locations" do
    @request.headers["REMOTE_ADDR"] = "8.8.8.8"
    I18n.locale = :en
    suggestion = GeoHelper.suggest @request
    assert_equal("Mountain View, California, United States", suggestion)
    I18n.locale = :es
  end

  test "does not suggests a location unless it's city-specific" do
    @request.headers["REMOTE_ADDR"] = "186.237.37.253"

    # This ip address is correctly resolved to Brazil, but not a specific city
    assert_nil GeoHelper.suggest @request
  end
end
