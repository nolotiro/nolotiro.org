require 'test_helper'

class GeoHelperTest < ActionView::TestCase
  include GeoHelper

  test "should get ip address" do
    ip = "87.223.138.147"
    @request.headers["REMOTE_ADDR"] = ip
    assert_equal(ip, "87.223.138.147")
  end 

  test "should suggest location with ip address" do
    suggestion = GeoHelper.suggest "87.221.25.121"
    assert_equal("Alcorcón, Madrid, España", suggestion)

    suggestion = GeoHelper.suggest "185.112.42.160"
    assert_equal("Madrid, Madrid, España", suggestion)

    suggestion = GeoHelper.suggest "8.8.8.8"
    assert_equal("Mountain View, California, United States", suggestion)
    
  end

end
