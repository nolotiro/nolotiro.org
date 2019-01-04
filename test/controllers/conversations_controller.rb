# frozen_string_literal: true

require "test_helper"

class ConversationsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  setup do
    @ad = create(:ad)
    @user1 = create(:user, email: "davidbowie@example.com", username: "davidbowie")
    @user2 = create(:user, email: "marcbolan@example.com", username: "trex")
  end

  it "redirects to signup to create a message as anon" do
    get :new, params: { user_id: @user1.id }
    assert_redirected_to new_user_session_url
  end

  it "gets form to create a message as an user" do
    sign_in @user1
    get :new, params: { user_id: @user2.id }
    assert_response :success
  end

  it "creates a message, shows it and lets the other user reply it" do
    # user1 signs in and sends a message to user2
    sign_in @user1
    assert_difference("Conversation.count") do
      post :create,
           params: {
             message: {
               recipients: @user2,
               body: "lo sigues teniendo? ",
               subject: "interesado en el ordenador"
             }
           }
    end
    m = Conversation.last
    assert_redirected_to conversation_path(m)

    sign_out @user1
    sign_in @user2
    get :show, params: { id: m.id }
    # TODO: assert flash
    # TODO: assert mailer
    # TODO: user2 signs in, read the message and reply it
    # TODO: user3 can't access that conversation
  end

  it "gets list of conversations as user" do
    sign_in @user1
    get :index
    assert_response :success
  end

  it "does not get list of conversations as anon" do
    get :index
    assert_redirected_to new_user_session_url
  end

  it "does not get list of conversations to/from another user" do
    sign_in @user1
    assert_difference("Conversation.count") do
      post :create,
           params: {
             message: {
               recipients: @user2,
               body: "lo sigues teniendo? ",
               subject: "interesado en el ordenador"
             }
           }
    end
    m = Conversation.last
    sign_out @user1
    user3 = create(:user, email: "brianeno@example.com", username: "eno")
    sign_in user3
    get :show, params: { id: m.id }
    assert_equal "No tienes permisos para realizar esta acción.", flash[:alert]
  end

  it "does not permit sender param for message" do
    sign_in @user1
    post :create,
         params: {
           message: {
             recipients: @user1,
             sender: @user2,
             body: "lo sigues teniendo? ",
             subject: "interesado en el ordenador"
           }
         }
    # TODO: finish
  end
end
