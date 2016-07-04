require 'test_helper'
require 'support/web_mocking'

class SearchControllerTest < ActionController::TestCase
  include WebMocking
  include Devise::Test::ControllerHelpers

  setup do
    @ad = FactoryGirl.create(:ad)
    @user = FactoryGirl.create(:user)
  end

  test "should work search with a WOEID param" do 
    mocking_yahoo_woeid_info(@ad.woeid_code) do
      get :search, {q: 'ordenador', woeid: @ad.woeid_code}
      assert_response :success
    end
  end

  test "should work search with a WOEID param - no results" do 
    mocking_yahoo_woeid_info(@ad.woeid_code) do
      get :search, q: 'notfound', woeid: @ad.woeid_code
      assert_response :success
    end
  end

  test "should work search with a logged in user with a WOEID code" do 
    mocking_yahoo_woeid_info(@user.woeid) do
      sign_in @user
      get :search, q: 'ordenador'
      assert_response :success
    end
  end
  
  test "should search work without WOEID param nor logged user" do
    get :search
    assert_response :redirect 
    assert_redirected_to location_ask_path
  end

end
