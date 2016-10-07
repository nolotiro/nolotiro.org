# frozen_string_literal: true

require 'test_helper'

class AnnouncementsTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers

  before do
    @active_announcement = create(:announcement, message: 'Blocking released!',
                                                 starts_at: 1.hour.ago,
                                                 ends_at: 1.hour.from_now)
  end

  it 'displays no announcements for anonymous visitors' do
    visit root_path

    assert_no_text @active_announcement.message
  end

  it 'displays active announcements' do
    login_as create(:user, woeid: nil)
    visit root_path

    assert_text @active_announcement.message
    logout
  end

  it 'properly dismisses announcements' do
    login_as create(:user, woeid: nil)
    visit root_path
    click_link '×'

    assert_no_text @active_announcement.message
    logout
  end

  it 'displays a single announcement at a time' do
    @active_announcement_two = create(:announcement, message: 'Magic released',
                                                     starts_at: 1.hour.ago,
                                                     ends_at: 1.minute.from_now)
    login_as create(:user, woeid: nil)
    visit root_path
    assert_text @active_announcement_two.message
    assert_no_text @active_announcement.message

    click_link '×'
    assert_text @active_announcement.message
    assert_no_text @active_announcement_two.message
    logout
  end
end
