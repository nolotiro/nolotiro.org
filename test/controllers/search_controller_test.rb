require 'test_helper'

class SearchControllerTest < ActionController::TestCase

  include Devise::TestHelpers

  setup do
    @ad = FactoryGirl.create(:ad)
    @user = FactoryGirl.create(:user)
    ThinkingSphinx::Test.index 'ad_core', 'ad_delta'
    ThinkingSphinx::Test.start
  end

  test "should work search with a WOEID param" do 
    get :search, {q: 'ordenador', woeid: @ad.woeid_code}
    assert_response :success
  end

  test "should work search with a WOEID param - no results" do 
    get :search, q: 'notfound', woeid: @ad.woeid_code
    assert_response :success
  end

  test "should work search with a logged in user with a WOEID code" do 
    sign_in @user
    get :search, q: 'ordenador'
    assert_response :success
  end
  
  test "should search work without WOEID param nor logged user" do
    get :search
    assert_response :redirect 
    assert_redirected_to location_ask_path
  end

end
