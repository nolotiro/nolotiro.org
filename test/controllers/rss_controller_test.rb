# frozen_string_literal: true

require "test_helper"

class RssControllerTest < ActionController::TestCase
  setup do
    @ad = create(:ad)
  end

  it "gets the feed for a WOEID" do
    get :feed, params: { woeid: @ad.woeid_code, type: "give", format: "rss" }

    assert_response :success
  end

  it "gets the feed for a WOEID/give/available" do
    get :feed, params: { woeid: @ad.woeid_code, type: "give", format: "rss" }

    assert_response :success
  end

  it "gets the feed for a WOEID/give/booked" do
    get :feed,
        params: {
          woeid: @ad.woeid_code, type: "give", status: "booked", format: "rss"
        }

    assert_response :success
  end

  it "gets the feed for a WOEID/give/delivered" do
    get :feed,
        params: {
          woeid: @ad.woeid_code, type: "give", status: "delivered", format: "rss"
        }

    assert_response :success
  end

  it "gets the feed for a WOEID/want" do
    get :feed, params: { woeid: @ad.woeid_code, type: "want", format: "rss" }

    assert_response :success
  end
end
