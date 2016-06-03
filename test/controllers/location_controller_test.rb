require 'test_helper'

class LocationControllerTest < ActionController::TestCase

  include Devise::TestHelpers

  setup do
    @user = FactoryGirl.create(:user)
    @request.headers["REMOTE_ADDR"] = "87.223.138.147"
  end

  test "should get ask location" do
    get :ask
    assert_response :success
  end

  test "should get location suggestion list" do
    # @todo We use a location without similar names to avoid touching the yahoo
    # API to resolve names for each similar city. Make this fast in another
    # way, either by caching resolved names in DB or mocking connections to the
    # Yahoo API
    get :list, location: "asdf"
    assert_response :success
  end

  test "should get location suggestion list (with post)" do
    # @todo We use a location without similar names to avoid touching the yahoo
    # API to resolve names for each similar city. Make this fast in another
    # way, either by caching resolved names in DB or mocking connections to the
    # Yahoo API
    post :list, location: "asdf"
    assert_response :success
  end

  test "should set location in my user" do
    sign_in @user
    post :change, location: 288888
    assert_response :redirect
    assert_redirected_to ads_woeid_path(288888, type: "give")
  end

  test "should set location in my session" do
    post :change, location: 288888
    assert_response :redirect
    assert_redirected_to ads_woeid_path(288888, type: "give")
  end

end
