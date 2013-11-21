require 'test_helper'

class GeoHelperTest < ActionView::TestCase
  include GeoHelper

  test "should_get_ip_address" do
    ip = "87.223.138.147"
    @request.headers["REMOTE_ADDR"] = ip
    assert_equal(ip, "87.223.138.147")
  end 

  test "should_suggest_location_with_ip_address" do
    suggestion = GeoHelper.suggest "87.218.80.79"
    assert_equal(suggestion, "Madrid, Madrid, España")
  end

end
