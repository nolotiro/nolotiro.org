require 'test_helper'

class CommentsControllerTest < ActionController::TestCase

  include Devise::TestHelpers

  setup do
    @ad = FactoryGirl.create(:ad)
    @user = FactoryGirl.create(:user, "email" => "jaimito@gmail.com", "username" => "jaimito")
  end

  test "should not create a comment as anonymous" do
    assert_difference('Comment.count', 0) do
      post :create, id: @ad.id, body: "hola mundo"
    end
    assert_response :redirect
    assert_redirected_to new_user_session_url
  end

  test "should create a comment as a user" do
    sign_in @user 
    assert_difference('Comment.count', 1) do
      post :create, id: @ad.id, body: "hola mundo"
    end
    assert_response :redirect
    assert_redirected_to ad_path(@ad)
  end

end
