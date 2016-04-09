require 'test_helper'

class WoeidControllerTest < ActionController::TestCase

  include Devise::TestHelpers

  setup do
    @ad = FactoryGirl.create(:ad)
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

  test "should get 404 on unexisting WOEID" do
    get :show, type: "want", id: "222222"
    assert_response 404
  end

end
