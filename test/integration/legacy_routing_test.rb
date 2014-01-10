require 'test_helper'

class LegacyRoutingTest < ActionDispatch::IntegrationTest

  setup do
    @ad = FactoryGirl.create(:ad)
    @user = FactoryGirl.create(:user)
    @another_user = FactoryGirl.create(:user)
    @admin = FactoryGirl.create(:admin)
  end

  test "should route to home" do
    assert_routing '/', {controller: "ads", action: "index"}
  end

  test "should route to given location" do
    assert_routing '/ca', {controller: "ads", action: "index", locale: "ca"}
    assert_routing '/en', {controller: "ads", action: "index", locale: "en"}
    assert_routing '/es', {controller: "ads", action: "index", locale: "es"}
    assert_routing '/fr', {controller: "ads", action: "index", locale: "fr"}
  end

  test "should route to WOEID ads" do
    assert_routing '/es/woeid/766273/give', {controller: "woeid", action: "show", locale: "es", id: "766273", type: "give"}
    assert_routing '/es/woeid/766273/give/status/booked', {controller: "woeid", action: "show", locale: "es", id: "766273", type: "give", status: "booked"}
    assert_routing '/es/woeid/766273/give/status/reserved', {controller: "woeid", action: "show", locale: "es", id: "766273", type: "give", status: "reserved"}
    assert_routing '/es/woeid/766273/want', {controller: "woeid", action: "show", locale: "es", id: "766273", type: "want"}
    assert_routing '/es/ad/listall/ad_type/give', {controller: "woeid", action: "show", locale: "es", type: "give"}
    assert_routing '/es/ad/listall/ad_type/give/status/available', {controller: "woeid", action: "show", locale: "es", type: "give", status: 'available'}
    assert_routing '/es/ad/listall/ad_type/give/status/booked', {controller: "woeid", action: "show", locale: "es", type: "give", status: 'booked'}
    assert_routing '/es/ad/listall/ad_type/give/status/delivered', {controller: "woeid", action: "show", locale: "es", type: "give", status: 'delivered'}
    assert_routing '/es/ad/listall/ad_type/want', {controller: "woeid", action: "show", locale: "es", type: "want"}
  end

  test "should route to location change" do
    assert_routing '/es/location/change', {controller: 'location', action: 'ask', locale: 'es'}
    assert_routing '/es/location/change2', {controller: 'location', action: 'change', locale: 'es'}
  end

  test "should route to pages" do 
    assert_routing '/es/pages/faqs', {controller: 'page', action: 'faqs', locale: 'es'}
    assert_routing '/es/pages/translate', {controller: 'page', action: 'translate', locale: 'es'}
    assert_routing '/es/pages/tos', {controller: 'page', action: 'tos', locale: 'es'}
    assert_routing '/es/pages/privacy', {controller: 'page', action: 'privacy', locale: 'es'}
    assert_routing '/es/pages/about', {controller: 'page', action: 'about', locale: 'es'}
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
    assert_routing "/es/message/list", {controller: "messages", action: "list", locale: "es"}
    assert_routing "/es/message/show/XXX/subject/XXX", {controller: "messages", action: "show", locale: "es", id: "XXX", subject: "XXX"}
  end

  test "should route auth" do 
    assert_routing '/es/user/register', {action: "new", controller: "registrations", locale: "es"}

    get '/es/auth/login'
    assert_redirected_to new_user_session_url

    get '/es/user/forgot'
    assert_redirected_to new_user_password_url
  end

  test "should get ads" do
    assert_routing '/es/ad/create', {action: "new", controller: "ads", locale: "es"}
    assert_routing "/es/ad/#{@ad.id}/#{@ad.slug}", {controller: "ads", action: "show", locale: "es", id: "#{@ad.id}", slug: "ordenador-en-vallecas"}

    #sign_in @user
    #get "/es/ad/edit/id/#{@ad.id}"
    #assert_redirected_to edit_ad_url(@ad)
  end

end
