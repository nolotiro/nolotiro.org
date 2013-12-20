require 'test_helper'

class WoeidControllerTest < ActionController::TestCase

  include Devise::TestHelpers

  setup do
    @ad = FactoryGirl.create(:ad)
  end

  test "should get listall - give and want" do 
    get :show, type: "give"
    assert_response :success
    get :show, type: "want"
    assert_response :success
  end

  test "should get listall and give (available, delivered, booked)" do 
    get :show, type: "give", status: "available"
    assert_response :success
    get :show, type: "give", status: "booked"
    assert_response :success
    get :show, type: "give", status: "delivered"
    assert_response :success
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
