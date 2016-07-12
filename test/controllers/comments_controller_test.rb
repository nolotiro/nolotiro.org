# frozen_string_literal: true
require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  setup do
    @ad = create(:ad)
  end

  test 'should not create a comment as anonymous' do
    assert_difference('Comment.count', 0) do
      post :create, id: @ad.id, body: 'hola mundo'
    end
    assert_response :redirect
    assert_redirected_to new_user_session_url
  end

  test 'should create a comment as a user' do
    sign_in @ad.user
    assert_difference('Comment.count', 1) do
      post :create, id: @ad.id, body: 'hola mundo'
    end
    assert_response :redirect
    assert_redirected_to ad_path(@ad)
  end
end
