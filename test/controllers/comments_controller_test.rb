# frozen_string_literal: true

require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  setup do
    @ad = create(:ad)
  end

  it 'does not create a comment as anonymous' do
    assert_difference('Comment.count', 0) do
      post :create, params: { ad_id: @ad.id, comment: { body: 'hola mundo' } }
    end
    assert_redirected_to new_user_session_url
  end

  it 'creates a comment as a user' do
    sign_in @ad.user
    assert_difference('Comment.count', 1) do
      post :create, params: { ad_id: @ad.id, comment: { body: 'hola mundo' } }
    end
    assert_redirected_to adslug_path(@ad, slug: @ad.slug)
  end
end
