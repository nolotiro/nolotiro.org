# frozen_string_literal: true

require "test_helper"
require "support/web_mocking"

module Api
  class V1ControllerTest < ActionController::TestCase
    include WebMocking

    setup { @ad = create(:ad, woeid_code: 766_273) }

    it "gets woeid list on api v1" do
      mocking_yahoo_woeid_info(766_273) do
        get :woeid_list, format: "json"
        body = JSON.parse(@response.body)
        body_expected = {
          "locations" => [
            { "woeid_id" => 766_273, "woeid_name" => "Madrid", "ads_count" => 1 }
          ]
        }

        assert_equal body_expected, body
        assert_equal 766_273, body["locations"][0]["woeid_id"]
        assert_response :success
      end
    end

    it "gets ad show on api v1" do
      get :ad_show, params: { format: "json", id: @ad }
      body = JSON.parse(@response.body)

      assert_equal 766_273, body["woeid_code"]
      assert_equal "ordenador en Vallecas", body["title"]
      assert_response :success
    end

    it "gets woeid show on a WOEID on api v1" do
      mocking_yahoo_woeid_info(766_273) do
        get :woeid_show, params: { format: "json", type: "give", id: 766_273 }
        body = JSON.parse(@response.body)

        assert_equal "766273", body["woeid_id"]
        assert_equal "Madrid, Madrid, España", body["woeid_name"]
        assert_equal "ordenador en Vallecas", body["ads"][0]["title"]
        assert_response :success
      end
    end
  end
end
