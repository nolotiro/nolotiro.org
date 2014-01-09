# encoding : utf-8
require 'test_helper'

class Api::V1ControllerTest < ActionController::TestCase

  setup do
    @ad = FactoryGirl.create(:ad)
    Rails.cache.clear
  end

  test "should get woeid list on api v1" do
    get :woeid_list, format: 'json'
    body = JSON.parse(@response.body)
    body_expected = {"locations"=>[{"woeid_id"=>766273, "woeid_name"=>"Madrid, Madrid, España", "ads_count"=>1}]}
    assert_equal(body, body_expected)
    assert_equal(body["locations"][0]["woeid_id"], 766273)
    assert_response :success
  end

  test "should get ad show on api v1" do
    get :ad_show, format: 'json', id: @ad
    body = JSON.parse(@response.body)
    assert_equal(body["woeid_code"], 766273)
    assert_equal(body["title"], "ordenador en Vallecas")
    assert_response :success
  end

  test "should get woeid show on a WOEID on api v1" do
    get :woeid_show, format: 'json', type: 'give', id: 766273
    body = JSON.parse(@response.body)
    assert_equal(body["woeid_id"], "766273")
    assert_equal(body["woeid_name"], "Madrid, Madrid, España")
    assert_equal(body["ads"][0]["title"], "ordenador en Vallecas" )
    assert_response :success
  end

end

