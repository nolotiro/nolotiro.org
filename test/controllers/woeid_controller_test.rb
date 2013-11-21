require 'test_helper'

class WoeidControllerTest < ActionController::TestCase

  include Devise::TestHelpers

  setup do
    @ad = FactoryGirl.create(:ad)
  end

  test "should get listall and give" do 
    get :listall_give
    assert_response :success
  end

  test "should get listall and give/available" do 
    get :listall_give_available
    assert_response :success
  end

  test "should get listall and give/booked" do 
    get :listall_give_booked
    assert_response :success
  end

  test "should get listall and give/delivered" do 
    get :listall_give_delivered
    assert_response :success
  end

  test "should get listall and want" do 
    get :listall_want
    assert_response :success
  end

  test "should get WOEID and give/available" do 
    get :available, id: @ad.woeid_code
    assert_response :success
  end

  test "should get WOEID and give/booked" do 
    get :booked, id: @ad.woeid_code
    assert_response :success
  end

  test "should get WOEID and give/delivered" do 
    get :delivered, id: @ad.woeid_code
    assert_response :success
  end

  test "should get WOEID and want" do 
    get :want, id: @ad.woeid_code
    assert_response :success
  end

end
