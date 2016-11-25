# encoding : utf-8
# frozen_string_literal: true

require 'test_helper'
require 'support/web_mocking'

class AdTest < ActiveSupport::TestCase
  include WebMocking

  test 'ad requires everything' do
    a = Ad.new
    a.valid?

    assert_not_empty a.errors[:body]
    assert_not_empty a.errors[:title]
    assert_not_empty a.errors[:user_owner]
    assert_not_empty a.errors[:type]
    assert_not_empty a.errors[:woeid_code]
  end

  test 'ad validates type' do
    assert_equal true, build(:ad, :give).valid?
    assert_equal true, build(:ad, :want).valid?
    assert_raises(ArgumentError) { build(:ad, type: :other) }
  end

  test 'ad validates status' do
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

  test 'ad validates maximum length of title' do
    assert_equal true, build(:ad, title: 'a' * 100).valid?
    assert_equal false, build(:ad, title: 'a' * 101).valid?
  end

  test 'ad validates minimum length of filtered title' do
    assert_equal true, build(:ad, title: 'a' * 4).valid?
    assert_equal false, build(:ad, title: 'a' * 3).valid?
    assert_equal true, build(:ad, title: 'Me llamo spammer@example.org').valid?
    assert_equal false, build(:ad, title: 'spammer@example.org').valid?
  end

  test 'ad title escapes privacy data' do
    text = 'por email example@example.com, o whatsapp al 666666666'
    expected_text = 'por email  , o   al  '
    ad = build(:ad, title: text)

    assert_equal expected_text, ad.filtered_title
  end

  test 'ad validates maximum length of body' do
    assert_equal true, build(:ad, body: 'a' * 1000).valid?
    assert_equal false, build(:ad, body: 'a' * 1001).valid?
  end

  test 'ad validates minimum length of filtered body' do
    assert_equal true, build(:ad, body: 'a' * 25).valid?
    assert_equal false, build(:ad, body: 'a' * 24).valid?
    assert_equal true, build(:ad, body: 'a' * 25 + ' spammer@example.org').valid?
    assert_equal false, build(:ad, body: 'a' * 22 + ' spammer@example.org').valid?
  end

  test 'ad body escapes privacy data' do
    text = 'por email example@example.com, o whatsapp al 666666666'
    expected_text = 'por email  , o   al  '
    ad = build(:ad, body: text)

    assert_equal expected_text, ad.filtered_body
  end

  test 'ad check slug' do
    ad = build(:ad, title: 'ordenador en Vallecas')

    assert_equal 'ordenador-en-vallecas', ad.slug
  end

  test 'ad check type_string' do
    assert_equal 'regalo', build(:ad, :give).type_string
    assert_equal 'petición', build(:ad, :want).type_string
  end

  test 'ad check status_string' do
    assert_equal 'disponible', build(:ad, :available).status_string
    assert_equal 'reservado', build(:ad, :booked).status_string
    assert_equal 'entregado', build(:ad, :delivered).status_string
  end

  test 'ad meta_title for give ads' do
    ad = build(:ad, :give)

    mocking_yahoo_woeid_info(ad.woeid_code) do
      title = 'regalo - ordenador en Vallecas - Madrid, Madrid, España'

      assert_equal title, ad.meta_title
    end
  end

  test 'ad meta_title for want ads' do
    ad = build(:ad, :want)

    mocking_yahoo_woeid_info(ad.woeid_code) do
      title = 'petición - ordenador en Vallecas - Madrid, Madrid, España'

      assert_equal title, ad.meta_title
    end
  end

  test 'ad body stores emoji' do
    ad = create(:ad, body: 'Pantalones cortos para el veranito! 😀 ')

    assert_equal 'Pantalones cortos para el veranito! 😀 ', ad.body
  end

  test 'ad bumping refreshes publication date' do
    ad = create(:ad, published_at: 1.week.ago)
    ad.bump

    assert_in_delta Time.zone.now.to_i, ad.published_at.to_i, 1
  end

  test 'ad bumping resets readed count' do
    ad = create(:ad, readed_count: 100)
    ad.bump

    assert_equal 1, ad.readed_count
  end

  test 'associated comments are deleted when ad is deleted' do
    comment = create(:comment)

    assert_difference(-> { Comment.count }, -1) { comment.ad.destroy }
  end

  test '.by_title ignores invalid bytes sequences' do
    assert_equal [], Ad.by_title("Física y Química 3º ESoC3\x93")
  end

  test '.move! changes ad type' do
    ad = create(:ad, :give)
    ad.move!
    assert_equal true, ad.want?

    ad.move!
    assert_equal true, ad.give?
  end

  test '.move! updates the status to keep the ad valid' do
    ad = create(:ad, :give)
    ad.move!
    assert_nil ad.status

    ad.move!
    assert_equal true, ad.available?
  end
end
