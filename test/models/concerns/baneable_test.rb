# frozen_string_literal: true

require 'test_helper'

class BaneableTest < ActiveSupport::TestCase
  before do
    @reported = create(:user)
  end

  describe '#reported?' do
    it 'returns whether the receiver user has reported the passed user' do
      reporter = create(:user)
      assert_equal false, reporter.reported?(@reported)

      reporter.report!(@reported)
      assert_equal true, reporter.reported?(@reported)
    end
  end

  describe '.reported' do
    it 'returns only users with received reports' do
      create(:user).report!(@reported)

      assert_equal [@reported], User.reported
    end

    it 'returns uniq users' do
      2.times { create(:user).report!(@reported) }

      assert_equal [@reported], User.reported
    end
  end

  describe '#report!' do
    it 'flags user when one report by a tl3 user' do
      reporter = create(:admin)
      assert_equal false, @reported.banned?

      reporter.report!(@reported)
      assert_equal true, @reported.banned?
    end

    it 'flags user when two reports by tl2 users' do
      reporter1 = create(:user, confirmed_at: 2.months.ago)
      create_list(:ad, 10, :give, user: reporter1)
      reporter2 = create(:user, confirmed_at: 2.months.ago)
      create_list(:ad, 11, :give, user: reporter2)
      ignored_reporter = create(:user, confirmed_at: 2.months.ago)
      create_list(:ad, 9, :give, user: ignored_reporter)
      assert_equal false, @reported.banned?

      reporter1.report!(@reported)
      assert_equal false, @reported.banned?

      ignored_reporter.report!(@reported)
      assert_equal false, @reported.banned?

      reporter2.report!(@reported)
      assert_equal true, @reported.banned?
    end

    it 'flags user when four reports by tl1 users' do
      reporters = create_list(:user, 4, confirmed_at: 3.weeks.ago)
      ignored_reporter = create(:user, confirmed_at: 10.hours.ago)
      assert_equal false, @reported.banned?

      reporters[0...-1].each do |reporter|
        reporter.report!(@reported)
        assert_equal false, @reported.banned?
      end

      ignored_reporter.report!(@reported)
      assert_equal false, @reported.banned?

      reporters.last.report!(@reported)
      assert_equal true, @reported.banned?
    end

    it 'ignores tl0 user reports' do
      reporters = create_list(:user, 5, confirmed_at: 10.hours.ago)

      reporters.each do |reporter|
        assert_equal false, @reported.banned?
        reporter.report!(@reported)
      end

      assert_equal false, @reported.banned?
    end
  end
end
