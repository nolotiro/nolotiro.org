require 'test_helper'

class FriendshipsControllerTest < ActionController::TestCase

  setup do
    @user = FactoryGirl.create(:user)
    @friend = FactoryGirl.create(:user, "email" => "jaimito@gmail.com", "username" => "jaimito")
  end

  test "should not create a friend as anonymous user" do
    post :create, :friend_id => @friend.id
    assert_response :success
  end

  test "should create a friend" do
    sign_in @user
    post :create, :friend_id => @friend.id
    assert_response :success
  end

  test "should destroy a friendship :(" do
    sign_in @user
    assert false
  end

end
