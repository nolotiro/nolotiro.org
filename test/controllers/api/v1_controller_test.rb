require 'test_helper'

class Api::V1ControllerTest < ActionController::TestCase

  setup do
    @ad = FactoryGirl.create(:ad)
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
    body_expected = {"title"=>"ordenador en Vallecas", "body"=>"pentium 9 con monitor de plasma de 90 pulgadas. pasar a recoger", "user_owner"=>1, "type"=>1, "woeid_code"=>766273, "date_created"=>"2013-11-01T09:41:00.000Z", "image_file_name"=>nil, "type_string"=>"regalo", "status"=>1, "status_string"=>"disponible"}
    assert_equal(body, body_expected)
    assert_equal(body["title"], "ordenador en Vallecas")
    assert_response :success
  end

  test "should get woeid show on a WOEID on api v1" do
    get :woeid_show, format: 'json', type: 'give', id: 766273
    body = JSON.parse(@response.body)
    body_expected = {"woeid_id"=>"766273", "woeid_name"=>"Madrid, Madrid, España", "ads"=>[{"id"=>1, "title"=>"ordenador en Vallecas", "body"=>"pentium 9 con monitor de plasma de 90 pulgadas. pasar a recoger"}]}
    assert_equal(body, body_expected)
    assert_equal(body["woeid_id"], "766273")
    assert_equal(body["woeid_name"], "Madrid, Madrid, España")
    assert_equal(body["ads"][0]["title"], "ordenador en Vallecas" )
    assert_response :success
  end

end

