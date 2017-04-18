# frozen_string_literal: true

require 'test_helper'

class AdValidationTest < ActiveSupport::TestCase
  test 'requires everything' do
    a = Ad.new
    a.valid?

    %i(body title user type woeid_code).each do |attribute|
      assert_not_empty a.errors[attribute]
    end
  end

  test 'validates type' do
    assert_equal true, build(:ad, :give).valid?
    assert_equal true, build(:ad, :want).valid?
    assert_raises(ArgumentError) { build(:ad, type: :other) }
  end

  test 'validates status' do
    assert_equal true, build(:ad, status: :available).valid?
    assert_equal true, build(:ad, status: :booked).valid?
    assert_equal true, build(:ad, status: :delivered).valid?
    assert_raises(ArgumentError) { build(:ad, status: :other) }
  end

  test 'requires non-nil status for give ads' do
    assert_equal false, build(:ad, type: :give, status: nil).valid?
  end

  test 'requires nil status for want ads' do
    assert_equal false, build(:ad, type: :want, status: :available).valid?
  end

  test 'validates maximum length of title' do
    assert_equal true, build(:ad, title: 'a' * 100).valid?
    assert_equal false, build(:ad, title: 'a' * 101).valid?
  end

  test 'validates minimum length of title' do
    assert_equal true, build(:ad, title: 'a' * 4).valid?
    assert_equal false, build(:ad, title: 'a' * 3).valid?
  end

  test 'validates maximum length of body' do
    assert_equal true, build(:ad, body: 'a' * 1000).valid?
    assert_equal false, build(:ad, body: 'a' * 1001).valid?
  end

  test 'validates minimum length of body' do
    assert_equal true, build(:ad, body: 'a' * 12).valid?
    assert_equal false, build(:ad, body: 'a' * 11).valid?
  end
end
