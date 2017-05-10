# frozen_string_literal: true

require 'test_helper'
require 'support/web_mocking'

class AdsControllerTest < ActionController::TestCase
  include WebMocking
  include Devise::Test::ControllerHelpers

  setup do
    @user = create(:user)
    @admin = create(:admin)
  end

  it 'should not get new if not signed in' do
    get :new

    assert_redirected_to new_user_session_url
  end

  it 'should get new if signed in' do
    mocking_yahoo_woeid_info(@user.woeid) do
      sign_in @user
      get :new

      assert_response :success
    end
  end

  it 'should not create ad if not signed in' do
    assert_difference('Ad.count', 0) { post :create, params: test_ad_params }
    assert_redirected_to new_user_session_url
  end

  it 'should create ad if logged in' do
    sign_in @user

    assert_difference('Ad.count', 1) { post :create, params: test_ad_params }
    assert_redirected_to adslug_path(Ad.first.id, slug: 'regalo-ferrari')
  end

  it 'should show ad' do
    @ad = create(:ad)

    mocking_yahoo_woeid_info(@ad.woeid_code) do
      get :show, params: { id: @ad.id, slug: @ad.slug }

      assert_response :success
    end
  end

  it 'redirects to new slugged URL after title changes' do
    @ad = create(:ad, title: 'My newww title')
    @ad.update!(title: 'My new title')

    mocking_yahoo_woeid_info(@ad.woeid_code) do
      get :show, params: { id: @ad.id, slug: 'my-newww-title' }

      assert_redirected_to adslug_path(@ad, slug: 'my-new-title')
    end
  end

  it 'should not edit any ad as normal user' do
    @ad = create(:ad, user_owner: @admin.id)
    sign_in @user
    get :edit, params: { id: @ad }

    assert_redirected_to root_path
  end

  it 'should edit my own ad as normal user' do
    @ad = create(:ad, user_owner: @user.id)
    sign_in @user
    get :edit, params: { id: @ad }

    assert_response :success
  end

  it 'should get edit as admin user' do
    @ad = create(:ad)
    sign_in @admin
    get :edit, params: { id: @ad }

    assert_response :success
  end

  it 'should not update other user ad if normal user' do
    @ad = create(:ad, user_owner: @admin.id)
    sign_in @user
    patch :update,
          params: { id: @ad,
                    ad: { body: @ad.body, title: @ad.title, type: @ad.type, woeid_code: @ad.woeid_code } }

    assert_redirected_to root_url
  end

  it 'should update own ads as normal user' do
    @ad = create(:ad, user_owner: @user.id)
    sign_in @user

    body = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged."
    patch :update,
          params: { id: @ad,
                    ad: { body: body, title: @ad.title, type: @ad.type, woeid_code: @ad.woeid_code } }

    assert_redirected_to adslug_path(@ad, slug: @ad.slug)
    assert_equal body, @ad.reload.body
  end

  it 'should update any ad as admin' do
    @ad = create(:ad)
    sign_in @admin
    patch :update,
          params: { id: @ad,
                    ad: { body: @ad.body, title: @ad.title, type: @ad.type, woeid_code: @ad.woeid_code } }

    assert_redirected_to adslug_path(@ad, slug: @ad.slug)
  end

  it 'should not destroy ad as anonymous' do
    @ad = create(:ad)
    assert_difference('Ad.count', 0) { delete :destroy, params: { id: @ad } }
    assert_redirected_to root_path
  end

  it 'should not destroy non-owned ads as normal user' do
    @ad = create(:ad)
    sign_in @user

    assert_difference('Ad.count', 0) { delete :destroy, params: { id: @ad } }
    assert_redirected_to root_path
  end

  private

  def test_ad_params
    {
      ad: {
        body: 'Es una Ferrari de esas rojas, muy linda.',
        title: 'Regalo Ferrari',
        type: 'give',
        woeid_code: '788273'
      }
    }
  end
end
