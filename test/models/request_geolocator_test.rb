# frozen_string_literal: true
require 'test_helper'

class RequestGeolocatorTest < ActionView::TestCase
  test 'extracts ip address from request headers' do
    @request.headers['REMOTE_ADDR'] = '87.223.138.147'
    ip = RequestGeolocator.new(@request).ip_address

    assert_equal '87.223.138.147', ip
  end 

  test 'suggests location from ip address' do
    @request.headers['REMOTE_ADDR'] = '8.8.8.8'
    suggestion = RequestGeolocator.new(@request).suggest

    assert_equal 'Mountain View, California, Estados Unidos',
                 suggestion.fullname
  end

  test 'suggests properly translated locations' do
    @request.headers['REMOTE_ADDR'] = '8.8.8.8'

    I18n.locale = :en
    suggestion = RequestGeolocator.new(@request).suggest
    assert_equal 'Mountain View, California, United States', suggestion.fullname
    I18n.locale = :es
  end

  test "does not suggests a location unless it's city-specific" do
    @request.headers['REMOTE_ADDR'] = '186.237.37.253'

    # This ip address is correctly resolved to Brazil, but not a specific city
    assert_nil RequestGeolocator.new(@request).suggest
  end
end
