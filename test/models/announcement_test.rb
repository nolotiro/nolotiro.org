# frozen_string_literal: true
require 'test_helper'

class AnnouncementTest < ActiveSupport::TestCase
  test '.current returns only active announcements' do
    _past = create(:announcement, starts_at: 1.day.ago, ends_at: 1.hour.ago)
    curr = create(:announcement, starts_at: 1.day.ago, ends_at: 1.day.from_now)
    _post = create(:announcement, starts_at: 1.hour.from_now,
                                  ends_at: 1.day.from_now)

    assert_equal [curr], Announcement.current
  end

  test '.pending_for returns not acknowleged announcements' do
    dismisser = create(:user)
    other = create(:user)

    pending = create(:announcement)
    acknowledged = create(:announcement, :acknowledged, dismisser: dismisser)

    assert_equal [pending], Announcement.pending_for(dismisser)
    assert_equal [pending, acknowledged], Announcement.pending_for(other)
  end

  test '.pick_pending_for returns pending announcement closest to expiration' do
    _curr1 = create(:announcement, ends_at: 1.hour.from_now)
    curr2 = create(:announcement, ends_at: 1.minute.from_now)

    assert_equal curr2, Announcement.pick_pending_for(create(:user))
  end
end
