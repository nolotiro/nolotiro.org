# frozen_string_literal: true

module Routing
  def assert_woeid_ad_routing(route, id: nil, type: nil, status: nil)
    keys = { controller: 'woeid', action: 'show', locale: 'es' }
    keys[:id] = id if id

    assert_ad_routing route, keys, type, status
  end

  def assert_user_routing(route, username: nil, type: nil, status: nil)
    keys = {
      controller: 'users',
      action: 'profile',
      locale: 'es',
      username: username || @user.username
    }

    assert_ad_routing route, keys, type, status
  end

  def assert_ad_routing(route, keys, type, status)
    keys[:type] = type if type
    keys[:status] = status if status

    assert_routing route, keys
  end
end
