require 'test_helper'

class MessagesControllerTest < ActionController::TestCase

  include Devise::TestHelpers

  setup do
    @ad = FactoryGirl.create(:ad)
    @user1 = FactoryGirl.create(:user, "email" => "davidbowie@gmail.com", "username" => "davidbowie")
    @user2 = FactoryGirl.create(:user, "email" => "marcbolan@gmail.com", "username" => "trex")
  end

  test "should redirect to signup to create a message as anon" do
    get :new, user_id: @user1.id
    assert_redirected_to new_user_session_url
  end

  test "should get form to create a message as an user" do
    sign_in @user1
    get :new, user_id: @user2.id
    assert_response :success
  end

  test "should create a message, show it and let the other user reply it" do
    # user1 signs in and sends a message to user2 
    sign_in @user1
    message = { body: "lo sigues teniendo? ", subject: "interesado en el ordenador" }
    expected_subject = message[:subject].parameterize
    assert_difference('Message.count') do
      post :create, user_id: @user2.id, message: message
    end
    assert_redirected_to message_show_path(id: assigns(:message), subject: expected_subject )
    sign_out @user1
    # TODO: assert flash 
    # TODO: assert mailer 
    # TODO: user2 signs in, read the message and reply it 
    sign_in @user2
    get :show, id: assigns(:message), subject: expected_subject
    # TODO: user3 can't access that conversation
  end

  test "should get list of conversations as user" do
    sign_in @user1
    get :list
    assert_response :success
  end

  test "should not get list of conversations as anon" do
    get :list
    assert_redirected_to new_user_session_url
  end

end
