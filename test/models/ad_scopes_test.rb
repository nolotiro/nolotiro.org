# frozen_string_literal: true

require 'test_helper'

class AdScopesTest < ActiveSupport::TestCase
  def setup
    super

    @available = create(:ad, :available)
    @booked = create(:ad, :booked)
    @delivered = create(:ad, :delivered)
    create(:ad, :want)

    @available_expired = create(:ad, :available, published_at: 2.months.ago)
    @booked_expired = create(:ad, :booked, published_at: 2.months.ago)
    @delivered_expired = create(:ad, :delivered, published_at: 2.months.ago)
    create(:ad, :want, published_at: 2.months.ago)
  end

  def test_currently_available_includes_not_expired_available_ads
    assert_equal Ad.currently_available, [@available]
  end

  def test_currently__includes_not_expired_booked_ads
    assert_equal Ad.currently_booked, [@booked]
  end

  def test_currently_delivered_includes_all_delivered_ads
    assert_equal Ad.currently_delivered.sort, [@delivered, @delivered_expired]
  end

  def test_currently_expired_includes_all_non_delivered_expired_ads
    assert_equal Ad.currently_expired.sort, [@available_expired, @booked_expired]
  end
end
