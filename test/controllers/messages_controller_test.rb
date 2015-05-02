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
    assert_difference('Mailboxer::Message.count') do
      post :create, mailboxer_message: { recipients: @user2, body: "lo sigues teniendo? ", subject: "interesado en el ordenador" }
    end
    m = Mailboxer::Message.last
    assert_redirected_to mailboxer_message_path(id: m.id)
    #asmailboxer_sert_redirected_to message_show_path(id: m.id, subject: m.subject )
    sign_out @user1
    sign_in @user2
    get :show, id: m.id
    # TODO: assert flash 
    # TODO: assert mailer 
    # TODO: user2 signs in, read the message and reply it 
    # TODO: user3 can't access that conversation
  end

  test "should get list of conversations as user" do
    sign_in @user1
    get :index
    assert_response :success
  end

  test "should not get list of conversations as anon" do
    get :index
    assert_redirected_to new_user_session_url
  end

  test "should not get list of conversations to/from another user" do
    sign_in @user1
    assert_difference('Mailboxer::Message.count') do
      post :create, mailboxer_message: { recipients: @user2, body: "lo sigues teniendo? ", subject: "interesado en el ordenador" }
    end
    m = Mailboxer::Message.last
    sign_out @user1
    user3 = FactoryGirl.create(:user, "email" => "brianeno@gmail.com", "username" => "eno")
    sign_in user3
    get :show, id: m.id
    assert_equal "No tienes permisos para realizar esta acción.", flash[:alert]
  end

  test "should not permit sender param for message" do
    sign_in @user1
    post :create, mailboxer_message: { recipients: @user1, sender: @user2, body: "lo sigues teniendo? ", subject: "interesado en el ordenador" }
    # TODO: finish
  end

end
