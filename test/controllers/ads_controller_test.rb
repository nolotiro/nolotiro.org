# frozen_string_literal: true

require 'test_helper'

class AdsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  setup do
    @user = create(:user)
    @admin = create(:admin)
  end

  it "does not get new if not signed in" do
    get :new

    assert_redirected_to new_user_session_url
  end

  test 'should get new if signed in' do
    sign_in @user
    get :new

    assert_response :success
  end

  it "does not create ad if not signed in" do
    assert_difference("Ad.count", 0) { post :create, params: test_ad_params }
    assert_redirected_to new_user_session_url
  end

  it "creates ad if logged in" do
    sign_in @user

    assert_difference("Ad.count", 1) { post :create, params: test_ad_params }
    assert_redirected_to adslug_path(Ad.first.id, slug: "regalo-ferrari")
  end

  test 'should show ad' do
    get :show, params: { id: @ad.id, slug: @ad.slug }

    assert_response :success
  end

  test 'redirects to slugged version from non-slugged one' do
    get :legacy_show, params: { id: @ad.id }

    assert_response :redirect
    assert_redirected_to adslug_path(@ad, slug: @ad.slug)
  end

  test 'redirects to new slugged URL after title changes' do
    old_slug = @ad.slug
    @ad.update!(title: 'My new title, mistyped something')

    get :show, params: { id: @ad.id, slug: old_slug }

    assert_response :redirect
    assert_redirected_to adslug_path(@ad, slug: @ad.slug)
  end

  it "does not edit any ad as normal user" do
    @ad = create(:ad, user_owner: @admin.id)
    sign_in @user
    get :edit, params: { id: @ad }

    assert_redirected_to root_path
  end

  it "edits my own ad as normal user" do
    @ad = create(:ad, user_owner: @user.id)
    sign_in @user
    get :edit, params: { id: @ad }

    assert_response :success
  end

  it "edits as admin user" do
    @ad = create(:ad)
    sign_in @admin
    get :edit, params: { id: @ad }

    assert_response :success
  end

  it "does not update other user ad if normal user" do
    @ad = create(:ad, user_owner: @admin.id)
    sign_in @user
    patch :update,
          params: { id: @ad,
                    ad: { body: @ad.body, title: @ad.title, type: @ad.type, woeid_code: @ad.woeid_code } }

    assert_redirected_to root_url
  end

  it "updates own ads as normal user" do
    @ad = create(:ad, user_owner: @user.id)
    sign_in @user

    body = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has ..."
    patch :update,
          params: { id: @ad,
                    ad: { body: body, title: @ad.title, type: @ad.type, woeid_code: @ad.woeid_code } }

    assert_redirected_to adslug_path(@ad, slug: @ad.slug)
    assert_equal body, @ad.reload.body
  end

  it "updates any ad as admin" do
    @ad = create(:ad)
    sign_in @admin
    patch :update,
          params: { id: @ad,
                    ad: { body: @ad.body, title: @ad.title, type: @ad.type, woeid_code: @ad.woeid_code } }

    assert_redirected_to adslug_path(@ad, slug: @ad.slug)
  end

  it "does not destroy ad as anonymous" do
    @ad = create(:ad)
    assert_difference("Ad.count", 0) { delete :destroy, params: { id: @ad } }
    assert_redirected_to root_path
  end

  it "does not destroy non-owned ads as normal user" do
    @ad = create(:ad)
    sign_in @user

    assert_difference("Ad.count", 0) { delete :destroy, params: { id: @ad } }
    assert_redirected_to root_path
  end

  private

  def test_ad_params
    {
      ad: {
        body: "Es una Ferrari de esas rojas, muy linda.",
        title: "Regalo Ferrari",
        type: "give",
        woeid_code: "788273"
      }
    }
  end
end
