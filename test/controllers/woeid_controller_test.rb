require 'test_helper'

class WoeidControllerTest < ActionController::TestCase

  include Devise::TestHelpers

  setup do
    # @todo We use a location (Río de Janeiro) with no similar names to avoid
    # touching the yahoo API to resolve names for each similar city. Make this
    # fast in another way, either by caching resolved names in DB or mocking
    # connections to the Yahoo API
    @ad = FactoryGirl.create(:ad, woeid_code: 455825)
  end

  test "should get listall and give (available, delivered, booked)" do
    get :show, type: "give", status: "available"
    assert_response :success
    get :show, type: "give", status: "booked"
    assert_response :success
    get :show, type: "give", status: "delivered"
    assert_response :success
    assert_generates '/ad/listall/ad_type/give', {controller: 'woeid', action: 'show', type: 'give' }
  end

  test "should get WOEID and give (available, delivered, booked)" do
    get :show, type: "give", status: "available", id: @ad.woeid_code
    assert_response :success
    get :show, type: "give", status: "booked", id: @ad.woeid_code
    assert_response :success
    get :show, type: "give", status: "delivered", id: @ad.woeid_code
    assert_response :success
  end

  test "should get WOEID and want" do
    get :show, type: "want", id: @ad.woeid_code
    assert_response :success
  end

end
