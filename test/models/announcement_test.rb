# frozen_string_literal: true

require 'test_helper'

class AnnouncementTest < ActiveSupport::TestCase
  test '.current returns only active announcements' do
    _expired = create(:announcement, :expired)
    current = create(:announcement, :current)
    _programmed = create(:announcement, :programmed)

    assert_equal [current], Announcement.current
  end

  test '.current ignores announcements for other locales' do
    current = create(:announcement, :current)
    _foreign = create(:announcement, :current, locale: 'eu')

    assert_equal [current], Announcement.current
  end

  test '.current returns never expiring announcements' do
    current = create(:announcement, :eternal)

    assert_equal [current], Announcement.current
  end

  test '.pending_for returns no announcements when all dismissed' do
    user1 = create(:user)
    user2 = create(:user)

    announcement = create(:announcement)
    create(:dismissal, user: user1, announcement: announcement)
    create(:dismissal, user: user2, announcement: announcement)

    assert_equal [], Announcement.pending_for(user1)
    assert_equal [], Announcement.pending_for(user2)
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
    _old = create(:announcement, ends_at: 1.hour.from_now)
    recent = create(:announcement, ends_at: 1.minute.from_now)

    assert_equal recent, Announcement.pick_pending_for(create(:user))
  end
end
