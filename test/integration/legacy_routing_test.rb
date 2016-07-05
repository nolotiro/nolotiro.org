require 'test_helper'
require 'support/web_mocking'

class LegacyRoutingTest < ActionDispatch::IntegrationTest
  include WebMocking

  setup do
    @ad = FactoryGirl.create(:ad)
    @user = FactoryGirl.create(:user)
    @another_user = FactoryGirl.create(:user)
    @admin = FactoryGirl.create(:admin)
  end

  I18n.available_locales.map(&:to_s).each do |l|
    test "should i18n for #{l} work" do
      mocking_yahoo_woeid_info(@ad.woeid_code, l) do
        assert_routing "/#{l}", {controller: "ads", action: "index", locale: l}
        get "/#{l}"
        assert_response :success, "couldn't GET /#{l}"
        I18n.locale = :es
      end
    end
  end

  test "should route to home" do
    assert_routing '/', {controller: "ads", action: "index"}
  end

  test "should route to WOEID ads" do
    assert_routing '/es/woeid/766273/give',
                   {controller: "woeid", action: "show", locale: "es", id: "766273", type: "give"}

    assert_routing '/es/woeid/766273/give/status/available',
                   {controller: "woeid", action: "show", locale: "es", id: "766273", type: "give", status: "available"}

    assert_routing '/es/woeid/766273/give/status/booked',
                   {controller: "woeid", action: "show", locale: "es", id: "766273", type: "give", status: "booked"}

    assert_routing '/es/woeid/766273/give/status/delivered',
                   {controller: "woeid", action: "show", locale: "es", id: "766273", type: "give", status: "delivered"}

    assert_routing '/es/woeid/766273/want',
                   {controller: "woeid", action: "show", locale: "es", id: "766273", type: "want"}

    assert_routing '/es/ad/listall/ad_type/give',
                   {controller: "woeid", action: "show", locale: "es", type: "give"}

    assert_routing '/es/ad/listall/ad_type/give/status/available',
                   {controller: "woeid", action: "show", locale: "es", type: "give", status: 'available'}

    assert_routing '/es/ad/listall/ad_type/give/status/booked',
                   {controller: "woeid", action: "show", locale: "es", type: "give", status: 'booked'}

    assert_routing '/es/ad/listall/ad_type/give/status/delivered',
                   {controller: "woeid", action: "show", locale: "es", type: "give", status: 'delivered'}

    assert_routing '/es/ad/listall/ad_type/want',
                   {controller: "woeid", action: "show", locale: "es", type: "want"}
  end

  test "should route to location change" do
    assert_routing '/es/location/change', {controller: 'location', action: 'ask', locale: 'es'}
    assert_routing '/es/location/change2', {controller: 'location', action: 'change', locale: 'es'}
  end

  test "should route to pages" do 
    assert_routing '/es/page/faqs', {controller: 'page', action: 'faqs', locale: 'es'}
    assert_routing '/es/page/translate', {controller: 'page', action: 'translate', locale: 'es'}
    get "/es/page/tos"
    assert_redirected_to "http://www.example.com/page/privacy"
    assert_routing '/es/page/privacy', {controller: 'page', action: 'privacy', locale: 'es'}
    assert_routing '/es/page/about', {controller: 'page', action: 'about', locale: 'es'}
  end

  test "should route to contact" do
    assert_routing '/es/contact', {controller: 'contact', action: 'new', locale: 'es'}
  end

  test "should route user profile" do 
    assert_routing "/es/profile/#{@user.id}", {controller: "users", action: "profile", locale: "es", username: "#{@user.id}"}
    assert_routing "/es/profile/#{@user.username}", {controller:"users", action: "profile", locale: "es", username: @user.username}
    assert_routing "/es/ad/listuser/id/#{@user.id}", {controller: "users", action: "listads", locale: "es", id: @user.id.to_s}
  end

  test "should route messaging" do 
    get "/es/message/show/XXX/subject/XXX"
    assert_redirected_to new_user_session_url
    get '/es/message/list'
    assert_redirected_to new_user_session_url
    post_via_redirect new_user_session_url, 'user[email]' => @user.email, 'user[password]' => @user.password
    get '/es/message/list'
    assert_routing "/es/messages", {controller: "messages", action: "index", locale: "es"}
    assert_routing "/es/message/show/XXX/subject/XXX", {controller: "messages", action: "show", locale: "es", id: "XXX", subject: "XXX"}
  end

  test "should route auth" do 
    assert_routing '/es/user/register', {action: "new", controller: "registrations", locale: "es"}
  end

  test "should get ads" do
    assert_routing '/es/ad/create', {action: "new", controller: "ads", locale: "es"}
    assert_routing "/es/ad/#{@ad.id}/#{@ad.slug}", {controller: "ads", action: "show", locale: "es", id: "#{@ad.id}", slug: "ordenador-en-vallecas"}

    #sign_in @user
    #get "/es/ad/edit/id/#{@ad.id}"
    #assert_redirected_to edit_ad_url(@ad)
  end

end
