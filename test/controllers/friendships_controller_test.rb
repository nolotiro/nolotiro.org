require 'test_helper'

class FriendshipsControllerTest < ActionController::TestCase

  include Devise::TestHelpers

  setup do
    @user = FactoryGirl.create(:user)
    @friend = FactoryGirl.create(:user, "email" => "jaimito@gmail.com", "username" => "jaimito")
  end

  test "should not create a friend as anonymous user" do
    post :create, id: @friend.id
    assert_redirected_to new_user_session_url
  end

  test "should create a friend" do
    sign_in @user
    post :create, id: @friend.id
    assert_redirected_to profile_path(@friend.username)
  end

  test "should destroy a friendship :(" do
    sign_in @user
    post :create, id: @friend.id
    assert_redirected_to profile_path(@friend.username)
  end

end
