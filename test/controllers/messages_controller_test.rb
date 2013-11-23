require 'test_helper'

class MessagesControllerTest < ActionController::TestCase

  include Devise::TestHelpers

  setup do
    @ad = FactoryGirl.create(:ad)
    @user1 = FactoryGirl.create(:user, "email" => "davidbowie@gmail.com", "username" => "davidbowie")
    @user2 = FactoryGirl.create(:user, "email" => "marcbolan@gmail.com", "username" => "trex")
  end

  test "should redirect to signup to create a message as anon" do
    get :create
    assert_redirected_to new_user_session_url
  end

  test "should get form to create a message as an user" do
    sign_in @user1
    get :create
    assert_response :success
  end

  test "should post a message to another user" do
    sign_in @user1
    post :create
    assert_response :success
  end

  test "should get show of a given conversation" do
    assert false
  end

  test "should reply in a conversation" do
    assert false
  end

  test "should get list of conversations" do
    assert false
  end


end
