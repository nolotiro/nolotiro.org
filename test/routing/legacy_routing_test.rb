# frozen_string_literal: true

require "test_helper"
require "support/routing"
require "support/web_mocking"

class LegacyRoutingTest < ActionDispatch::IntegrationTest
  include Routing
  include WebMocking

  before do
    @ad = create(:ad)
    @user = create(:user)
    @another_user = create(:user)
    @admin = create(:admin)
  end

  def test_route_to_home
    assert_recognizes(
      { controller: "woeid", action: "show", type: "give" }, "/"
    )
  end

  def test_route_to_woeid_ads
    assert_woeid_ad_routing "/es/woeid/766273/give", id: "766273", type: "give"

    assert_woeid_ad_routing "/es/woeid/766273/give/status/available",
                            id: "766273",
                            type: "give",
                            status: "available"

    assert_woeid_ad_routing "/es/woeid/766273/give/status/booked",
                            id: "766273",
                            type: "give",
                            status: "booked"

    assert_woeid_ad_routing "/es/woeid/766273/give/status/delivered",
                            id: "766273",
                            type: "give",
                            status: "delivered"

    assert_woeid_ad_routing "/es/woeid/766273/want", id: "766273", type: "want"
  end

  def test_route_to_listall_ads
    assert_woeid_ad_routing "/es/ad/listall/ad_type/give", type: "give"
    assert_woeid_ad_routing "/es/ad/listall/ad_type/give/status/available", type: "give", status: "available"
    assert_woeid_ad_routing "/es/ad/listall/ad_type/give/status/booked", type: "give", status: "booked"
    assert_woeid_ad_routing "/es/ad/listall/ad_type/give/status/delivered", type: "give", status: "delivered"
    assert_woeid_ad_routing "/es/ad/listall/ad_type/want", type: "want"
  end

  def test_routes_to_location_change
    assert_routing "/es/location/change", controller: "location", action: "ask", locale: "es"
    assert_routing "/es/location/change2", controller: "location", action: "change", locale: "es"
  end

  def test_routes_to_pages
    assert_routing "/es/page/faqs", controller: "page", action: "faqs", locale: "es"
    assert_routing "/es/page/rules", controller: "page", action: "rules", locale: "es"
    assert_routing "/es/page/translate", controller: "page", action: "translate", locale: "es"
    assert_routing "/es/page/privacy", controller: "page", action: "privacy", locale: "es"
    assert_routing "/es/page/about", controller: "page", action: "about", locale: "es"
  end

  def test_routes_to_contact
    assert_routing "/es/contact", controller: "contact", action: "new", locale: "es"
  end

  def test_routes_to_user_profile
    assert_user_routing "/es/profile/#{@user.username}"
    assert_user_routing "/es/profile/#{@user.id}", username: @user.id.to_s
  end

  def test_routes_to_user_present_list
    assert_user_routing "/es/profile/#{@user.username}/type/give", type: "give"
    assert_user_routing "/es/profile/#{@user.id}/type/give", type: "give", username: @user.id.to_s
  end

  def test_routes_to_user_petition_list
    assert_user_routing "/es/profile/#{@user.username}/type/want", type: "want"
    assert_user_routing "/es/profile/#{@user.id}/type/want", type: "want", username: @user.id.to_s
  end

  def test_routes_to_user_available_ads
    assert_user_routing "/es/profile/#{@user.username}/type/give/status/available",
                        type: "give",
                        status: "available"

    assert_user_routing "/es/profile/#{@user.id}/type/give/status/available",
                        type: "give",
                        status: "available",
                        username: @user.id.to_s
  end

  def test_routes_to_user_booked_ads
    assert_user_routing "/es/profile/#{@user.username}/type/give/status/booked",
                        type: "give",
                        status: "booked"

    assert_user_routing "/es/profile/#{@user.id}/type/give/status/booked",
                        type: "give",
                        status: "booked",
                        username: @user.id.to_s
  end

  def test_routes_to_user_delivered_ads
    assert_user_routing "/es/profile/#{@user.username}/type/give/status/delivered",
                        type: "give",
                        status: "delivered"

    assert_user_routing "/es/profile/#{@user.id}/type/give/status/delivered",
                        type: "give",
                        status: "delivered",
                        username: @user.id.to_s
  end

  def test_routes_to_user_expired_ads
    assert_user_routing "/es/profile/#{@user.username}/type/give/status/expired",
                        type: "give",
                        status: "expired"

    assert_user_routing "/es/profile/#{@user.id}/type/give/status/expired",
                        type: "give",
                        status: "expired",
                        username: @user.id.to_s
  end

  def test_routes_auth
    assert_routing "/es/user/register", action: "new", controller: "registrations", locale: "es"
  end

  def test_routes_to_ad_management
    assert_routing "/es/ad/create", action: "new", controller: "ads", locale: "es"

    assert_routing "/es/ad/#{@ad.id}/#{@ad.slug}",
                   controller: "ads",
                   action: "show",
                   locale: "es",
                   id: @ad.id.to_s,
                   slug: "ordenador-en-vallecas"
  end
end
