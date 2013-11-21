require 'test_helper'

class SearchControllerTest < ActionController::TestCase

  include Devise::TestHelpers

  setup do
    @ad = FactoryGirl.create(:ad)
    @user = FactoryGirl.create(:user, "email" => "jaimito@gmail.com", "username" => "jaimito")
    ThinkingSphinx::Test.index 'ad_core', 'ad_delta'
    ThinkingSphinx::Test.start
  end

  test "should work search with a WOEID param" do 
    get :search, q: 'ordenador', id: @ad.woeid_code
    assert_response :success
  end

  test "should work search without WOEID param but a logged in user" do 
    sign_in @user
    get :search, q: 'ordenador'
    assert_response :success
  end

end
