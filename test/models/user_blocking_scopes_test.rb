# frozen_string_literal: true

require 'test_helper'

class UserBlockingScopesTest < ActiveSupport::TestCase
  setup do
    @neutral, @blocker, @blocked = create_list(:user, 3)
  end

  test '.whitelisting' do
    create(:blocking, blocker: @blocker, blocked: @blocked)
    assert_equal [@neutral, @blocked], User.whitelisting(@blocked)

    create(:blocking, blocker: @blocker, blocked: @neutral)
    assert_equal [@neutral, @blocked], User.whitelisting(@blocked)
  end
end
