require 'test_helper'

# 
class TestMockupRequest

  def initialize(remote_ip, http_x_forwarded_for) 
    @remote_ip = remote_ip
    @http_x_forwarded_for = http_x_forwarded_for
  end

  def remote_ip
    @remote_ip
  end

  def env
    @http_x_forwarded_for
  end

end

class GeoHelperTest < ActionView::TestCase
  include GeoHelper

  test "should_get_ip_address" do
    request = TestMockupRequest.new
    ip = GeoHelper.get_ip_address request
    assert_equal(ip, "87.223.138.147")
  end 

  test "should_get_ip_address_with_http_x_forwared_for" do
    # TODO
    request = {}
    ip = GeoHelper.get_ip_address request
    assert_equal(ip, "87.218.80.79")
  end 

  test "should_get_ip_address_with_remote_ip" do
    # TODO
    request = {}
    ip = GeoHelper.get_ip_address request
    assert_equal(ip, "87.218.80.79")
  end 

  test "should_suggest_location_with_ip_address" do
    # TODO
  end

end
