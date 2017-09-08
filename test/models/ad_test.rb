# frozen_string_literal: true

require 'test_helper'
require 'support/web_mocking'

class AdTest < ActiveSupport::TestCase
  include WebMocking

  it '#filtered_title escapes privacy data' do
    text = 'por email example@example.com, o whatsapp al 666666666'

    expected_text = <<-TXT.squish
      por email [INFORMACIÓN PRIVADA OCULTA], o [INFORMACIÓN PRIVADA OCULTA] al
      [INFORMACIÓN PRIVADA OCULTA]
    TXT

    ad = build(:ad, title: text)

    assert_equal expected_text, ad.filtered_title
  end

  it '#filtered_body escapes privacy data' do
    text = 'por email example@example.com, o whatsapp al 666666666'

    expected_text = <<-TXT.squish
      por email [INFORMACIÓN PRIVADA OCULTA], o [INFORMACIÓN PRIVADA OCULTA] al
      [INFORMACIÓN PRIVADA OCULTA]
    TXT

    ad = build(:ad, body: text)

    assert_equal expected_text, ad.filtered_body
  end

  it '#slug' do
    ad = build(:ad, title: 'ordenador en Vallecas')

    assert_equal 'ordenador-en-vallecas', ad.slug
  end

  it '#type_string' do
    assert_equal 'regalo', build(:ad, :give).type_string
    assert_equal 'petición', build(:ad, :want).type_string
  end

  it '#status_string' do
    assert_equal 'disponible', build(:ad, :available).status_string
    assert_equal 'reservado', build(:ad, :booked).status_string
    assert_equal 'entregado', build(:ad, :delivered).status_string
  end

  it '#meta_title for give ads' do
    ad = build(:ad, :give)

    mocking_yahoo_woeid_info(ad.woeid_code) do
      title = 'regalo - ordenador en Vallecas - Madrid, Madrid, España'

      assert_equal title, ad.meta_title
    end
  end

  it '#meta_title for want ads' do
    ad = build(:ad, :want)

    mocking_yahoo_woeid_info(ad.woeid_code) do
      title = 'petición - ordenador en Vallecas - Madrid, Madrid, España'

      assert_equal title, ad.meta_title
    end
  end

  it '#body stores emoji' do
    ad = create(:ad, body: 'Pantalones cortos para el veranito! 😀 ')

    assert_equal 'Pantalones cortos para el veranito! 😀 ', ad.body
  end

  it '#bump refreshes publication date' do
    ad = create(:ad, published_at: 1.week.ago)
    ad.bump

    assert_in_delta Time.zone.now.to_i, ad.published_at.to_i, 1
  end

  it '#bump resets readed count' do
    ad = create(:ad, readed_count: 100)
    ad.bump

    assert_equal 1, ad.readed_count
  end

  it '#bump deletes associated comments' do
    comment = create(:comment)

    assert_difference(-> { Comment.count }, -1) { comment.ad.bump }
  end

  it 'associated comments are deleted when ad is deleted' do
    comment = create(:comment)

    assert_difference(-> { Comment.count }, -1) { comment.ad.destroy }
  end

  it '.by_title ignores invalid bytes sequences' do
    assert_equal [], Ad.by_title("Física y Química 3º ESoC3\x93")
  end

  it '.move! changes ad type' do
    ad = create(:ad, :give)
    ad.move!
    assert_equal true, ad.want?

    ad.move!
    assert_equal true, ad.give?
  end

  it '.move! updates the status to keep the ad valid' do
    ad = create(:ad, :give)
    ad.move!
    assert_nil ad.status

    ad.move!
    assert_equal true, ad.available?
  end

  it '#reported_by?' do
    reporter = create(:user)
    ad = create(:ad)
    assert_equal false, ad.reported_by?(reporter)

    create(:report, ad: ad, reporter: reporter)
    assert_equal true, ad.reported_by?(reporter)
  end
end
