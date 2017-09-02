# frozen_string_literal: true

require 'test_helper'
require 'support/web_mocking'

class LegacyRoutingTest < ActionDispatch::IntegrationTest
  include WebMocking

  before do
    @ad = create(:ad)
    @user = create(:user)
    @another_user = create(:user)
    @admin = create(:admin)
  end

  I18n.available_locales.each do |l|
    define_method(:"test_i18n_for_#{l}_works") do
      I18n.with_locale(:es) do
        mocking_yahoo_woeid_info(@ad.woeid_code, l) do
          params = {
            controller: 'woeid', action: 'show', type: 'give', locale: l.to_s
          }
          assert_recognizes params, "/#{l}"
          get "/#{l}"
          assert_response :success, "couldn't GET /#{l}"
        end
      end
    end
  end

  def test_route_to_home
    assert_recognizes(
      { controller: 'woeid', action: 'show', type: 'give' }, '/'
    )
  end

  def test_route_to_woeid_ads
    assert_woeid_ad_routing '/es/woeid/766273/give', id: '766273', type: 'give'
    assert_woeid_ad_routing '/es/woeid/766273/give/status/available', id: '766273', type: 'give', status: 'available'
    assert_woeid_ad_routing '/es/woeid/766273/give/status/booked', id: '766273', type: 'give', status: 'booked'
    assert_woeid_ad_routing '/es/woeid/766273/give/status/delivered', id: '766273', type: 'give', status: 'delivered'
    assert_woeid_ad_routing '/es/woeid/766273/want', id: '766273', type: 'want'
    assert_woeid_ad_routing '/es/ad/listall/ad_type/give', type: 'give'
    assert_woeid_ad_routing '/es/ad/listall/ad_type/give/status/available', type: 'give', status: 'available'
    assert_woeid_ad_routing '/es/ad/listall/ad_type/give/status/booked', type: 'give', status: 'booked'
    assert_woeid_ad_routing '/es/ad/listall/ad_type/give/status/delivered', type: 'give', status: 'delivered'
    assert_woeid_ad_routing '/es/ad/listall/ad_type/want', type: 'want'
  end

  def test_routes_to_location_change
    assert_routing '/es/location/change', controller: 'location', action: 'ask', locale: 'es'
    assert_routing '/es/location/change2', controller: 'location', action: 'change', locale: 'es'
  end

  def test_routes_to_pages
    assert_routing '/es/page/faqs', controller: 'page', action: 'faqs', locale: 'es'
    assert_routing '/es/page/rules', controller: 'page', action: 'rules', locale: 'es'
    assert_routing '/es/page/translate', controller: 'page', action: 'translate', locale: 'es'
    assert_routing '/es/page/privacy', controller: 'page', action: 'privacy', locale: 'es'
    assert_routing '/es/page/about', controller: 'page', action: 'about', locale: 'es'
  end

  def test_routes_to_contact
    assert_routing '/es/contact', controller: 'contact', action: 'new', locale: 'es'
  end

  def test_routes_to_user_profile
    assert_routing "/es/profile/#{@user.id}", controller: 'users', action: 'profile', locale: 'es', id: @user.id.to_s
    assert_routing "/es/profile/#{@user.username}", controller: 'users', action: 'profile', locale: 'es', id: @user.username

    assert_user_ad_routing "/es/ad/listuser/id/#{@user.id}/type/give", type: 'give'
    assert_user_ad_routing "/es/ad/listuser/id/#{@user.id}/type/give", type: 'give'
    assert_user_ad_routing "/es/ad/listuser/id/#{@user.id}/type/give/status/available", type: 'give', status: 'available'
    assert_user_ad_routing "/es/ad/listuser/id/#{@user.id}/type/give/status/booked", type: 'give', status: 'booked'
    assert_user_ad_routing "/es/ad/listuser/id/#{@user.id}/type/give/status/delivered", type: 'give', status: 'delivered'
    assert_user_ad_routing "/es/ad/listuser/id/#{@user.id}/type/give/status/expired", type: 'give', status: 'expired'
  end

  def test_routes_auth
    assert_routing '/es/user/register', action: 'new', controller: 'registrations', locale: 'es'
  end

  def test_routes_to_ad_management
    assert_routing '/es/ad/create', action: 'new', controller: 'ads', locale: 'es'
    assert_routing "/es/ad/#{@ad.id}/#{@ad.slug}", controller: 'ads', action: 'show', locale: 'es', id: @ad.id.to_s, slug: 'ordenador-en-vallecas'
  end

  private

  def assert_woeid_ad_routing(route, id: nil, type: nil, status: nil)
    keys = { controller: 'woeid', action: 'show', locale: 'es' }

    assert_ad_routing route, keys, id, type, status
  end

  def assert_user_ad_routing(route, type: nil, status: nil)
    keys = { controller: 'users', action: 'listads', locale: 'es' }

    assert_ad_routing route, keys, @user.id.to_s, type, status
  end

  def assert_ad_routing(route, keys, id, type, status)
    keys[:id] = id if id
    keys[:type] = type if type
    keys[:status] = status if status

    assert_routing route, keys
  end
end
