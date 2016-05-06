require 'test_helper'

class GeoHelperTest < ActionView::TestCase
  include GeoHelper

  test "should get ip address" do
    ip = "87.223.138.147"
    @request.headers["REMOTE_ADDR"] = ip
    assert_equal(ip, "87.223.138.147")
  end 

  test "should suggest location with ip address" do
    suggestion = GeoHelper.suggest "8.8.8.8"
    assert_equal("Mountain View, California, Estados Unidos", suggestion)
  end

  test "should suggest properly translated locations" do
    I18n.locale = :en
    suggestion = GeoHelper.suggest "8.8.8.8"
    assert_equal("Mountain View, California, United States", suggestion)
    I18n.locale = :es
  end
end
