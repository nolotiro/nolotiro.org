# frozen_string_literal: true

require 'test_helper'

class WoeidControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  setup do
    @ad = create(:ad)
  end

  test 'should get listall and give (available, delivered, booked)' do
    get :show, params: { type: 'give', status: 'available' }
    assert_response :success
    get :show, params: { type: 'give', status: 'booked' }
    assert_response :success
    get :show, params: { type: 'give', status: 'delivered' }
    assert_response :success
    assert_generates '/ad/listall/ad_type/give',
                     controller: 'woeid', action: 'show', type: 'give'
  end

  test 'should get WOEID and give (available, delivered, booked)' do
    get :show, params: { type: 'give', status: 'available', id: @ad.woeid_code }
    assert_response :success
    get :show, params: { type: 'give', status: 'booked', id: @ad.woeid_code }
    assert_response :success
    get :show, params: { type: 'give', status: 'delivered', id: @ad.woeid_code }
    assert_response :success
  end

  test 'should get WOEID and want' do
    get :show, params: { type: 'want', id: @ad.woeid_code }
    assert_response :success
  end

  test 'accepts a query search parameter' do
    get :show, params: { type: 'give', q: 'ordenador', id: @ad.woeid_code }
    assert_response :success
  end

  test 'accepts a query search parameter when no results' do
    get :show, params: { type: 'give', q: 'notfound', id: @ad.woeid_code }
    assert_response :success
  end

  test 'accepts a query search parameter when WOEID code param not specified' do
    get :show, params: { type: 'give', q: 'ordenador' }
    assert_response :success
  end
end
