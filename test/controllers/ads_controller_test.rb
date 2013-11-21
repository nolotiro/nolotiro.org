require 'test_helper'

class AdsControllerTest < ActionController::TestCase
  # Test the CRUD scaffolded actions as anon, logged in user and admin
  #

  include Devise::TestHelpers

  setup do
    @ad = FactoryGirl.create(:ad)
    @user = FactoryGirl.create(:user, "email" => "jaimito@gmail.com", "username" => "jaimito")
    @admin = FactoryGirl.create(:admin)
  end

  test "should get index" do
    @request.headers["REMOTE_ADDR"] = "87.223.138.147"
    get :index
    assert_response :success
    assert_not_nil assigns(:ads)
  end

  test "should not get new if not signed in" do
    get :new
    assert_response :redirect
    assert_redirected_to new_user_session_url
  end

  test "should get new if signed in" do
    sign_in @user
    get :new
    assert_response :success
  end

  test "should create ad" do
    assert_difference('Ad.count') do
      post :create, ad: { body: @ad.body, ip: @ad.ip, title: @ad.title, type: @ad.type, user_owner: @ad.user_owner, woeid_code: @ad.woeid_code }
    end

    assert_redirected_to ad_path(assigns(:ad))
  end

  test "should show ad" do
    get :show, id: @ad.id
    assert_response :success
  end

  test "should not edit any ad as normal user" do
    @ad.user_owner = @admin.id
    @ad.save
    sign_in @user
    get :edit, id: @ad
    assert_response :redirect
    assert_redirected_to root_path 
  end

  test "should edit my own ad as normal user" do
    @ad.user_owner = @user.id
    @ad.save
    sign_in @user
    get :edit, id: @ad
    assert_response :success
  end

  test "should get edit as admin user" do
    sign_in @admin
    get :edit, id: @ad
    assert_response :success
  end

  test "should not update other user ad if normal user" do
    @ad.user_owner = @admin.id
    @ad.save
    sign_in @user
    patch :update, id: @ad, ad: { body: @ad.body, ip: @ad.ip, title: @ad.title, type: @ad.type, user_owner: @ad.user_owner, woeid_code: @ad.woeid_code }
    assert_redirected_to root_url
  end

  test "should update own ads as normal user" do
    sign_in @user
    @ad.user_owner = @user.id
    @ad.save
    patch :update, id: @ad, ad: { body: "nuevo texto", ip: @ad.ip, title: @ad.title, type: @ad.type, user_owner: @ad.user_owner, woeid_code: @ad.woeid_code }
    assert_redirected_to ad_path(assigns(:ad))
  end

  test "should update any ad as admin" do
    sign_in @admin
    patch :update, id: @ad, ad: { body: @ad.body, ip: @ad.ip, title: @ad.title, type: @ad.type, user_owner: @ad.user_owner, woeid_code: @ad.woeid_code }
    assert_redirected_to ad_path(assigns(:ad))
  end

  test "should not destroy ad as anonymous" do
    assert_difference('Ad.count', 0) do
      delete :destroy, id: @ad
    end

    assert_redirected_to new_user_session_url
  end

  test "should not destroy ad as normal user" do
    sign_in @user
    assert_difference('Ad.count', 0) do
      delete :destroy, id: @ad
    end

    assert_redirected_to root_path
  end

  test "should destroy ad as admin user" do
    sign_in @admin
    assert_difference('Ad.count', -1) do
      delete :destroy, id: @ad
    end

    assert_redirected_to ads_path
  end

end
