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
    assert_redirected_to root_path
    assert_equal "No tienes permisos para realizar esta acción.", flash[:alert]
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
    assert_redirected_to root_path
    assert_equal "No tienes permisos para realizar esta acción.", flash[:alert]
    assert_equal(@user.locked?, false)
    get :unlock, id: @another_user.id
    assert_redirected_to root_path
    assert_equal "No tienes permisos para realizar esta acción.", flash[:alert]
  end

  test "should lock or unlock an user as admin" do
    sign_in @admin
    get :lock, id: @user.id
    assert_redirected_to profile_url(@user)
    assert_equal("Successfully locked user #{@user.username}. The user can't log in.", flash[:notice])
    user = User.find @user.id
    assert_equal(user.active_for_authentication?, false)
    get :unlock, id: @user.id
    assert_redirected_to profile_url(@user)
    user = User.find @user.id
    assert_equal(user.locked?, false)
    assert_equal(user.active_for_authentication?, true)
    assert_equal("Successfully unlocked user #{@user.username}. The user can log in.", flash[:notice])
  end

end
