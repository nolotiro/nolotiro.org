require 'test_helper'

class AdminControllerTest < ActionController::TestCase

  include Devise::TestHelpers

  setup do
    @ad = FactoryGirl.create(:ad)
    @user = FactoryGirl.create(:user)
    @another_user = FactoryGirl.create(:user)
    @admin = FactoryGirl.create(:admin)
  end

  test "should not become an user as a anonymous user" do
    get :become, id: @user.id
    assert_redirected_to new_user_session_url
  end

  test "should not become an user as a normal user" do
    sign_in @user
    get :become, id: @another_user.id
    assert_redirected_to new_user_session_url
  end

  test "should become an user as admin" do
    sign_in @admin
    get :become, id: @user.id
    assert_redirected_to root_path
  end

  test "should not lock or unlock an user as a anonymous user" do
    get :lock, id: @user.id
    assert_redirected_to new_user_session_url
    assert_equal(@user.locked?, false)
    get :unlock, id: @user.id
    assert_redirected_to new_user_session_url
  end

  test "should not lock or unlock an user as a normal user" do
    sign_in @user
    get :lock, id: @another_user.id
    assert_redirected_to new_user_session_url
    assert_equal(@user.locked?, false)
    get :unlock, id: @another_user.id
    assert_redirected_to new_user_session_url
  end

  test "should lock or unlock an user as admin" do
    sign_in @admin
    get :lock, id: @user.id
    assert_redirected_to root_path
    assert_equal(@user.locked?, true)
    get :unlock, id: @user.id
    assert_redirected_to root_path
    assert_equal(@user.locked?, false)
  end

end
