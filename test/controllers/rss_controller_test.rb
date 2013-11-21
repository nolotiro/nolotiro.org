require 'test_helper'

class RssControllerTest < ActionController::TestCase

  setup do
    @ad = FactoryGirl.create(:ad)
  end

  test "should get the feed for a WOEID" do
    get :feed, woeid: @ad.woeid_code, type: 'give', format: 'rss'
    assert_response :success
  end

  test "should get the feed for a WOEID/give/available" do
    get :feed, woeid: @ad.woeid_code, type: 'give', format: 'rss'
    assert_response :success
  end

  test "should get the feed for a WOEID/give/booked" do
    get :feed, woeid: @ad.woeid_code, type: 'give', status: 'booked', format: 'rss'
    assert_response :success
  end

  test "should get the feed for a WOEID/give/delivered" do
    get :feed, woeid: @ad.woeid_code, type: 'give', status: 'delivered', format: 'rss'
    assert_response :success
  end

  test "should get the feed for a WOEID/want" do
    get :feed, woeid: @ad.woeid_code, type: 'want', format: 'rss'
    assert_response :success
  end

end
