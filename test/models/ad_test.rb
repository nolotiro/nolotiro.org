# encoding : utf-8
# frozen_string_literal: true

require 'test_helper'
require 'support/web_mocking'

class AdTest < ActiveSupport::TestCase
  include WebMocking

  setup { @ad = create(:ad) }

  test 'ad requires everything' do
    a = Ad.new
    a.valid?
    assert_not_empty a.errors[:status]
    assert_not_empty a.errors[:body]
    assert_not_empty a.errors[:title]
    assert_not_empty a.errors[:user_owner]
    assert_not_empty a.errors[:type]
    assert_not_empty a.errors[:woeid_code]
  end

  test 'ad validates type' do
    assert_equal true, @ad.update(type: :give)
    assert_equal true, @ad.update(type: :want)
    assert_raises(ArgumentError) { @ad.update(type: :other) }
  end

  test 'ad validates status' do
    assert_equal true, @ad.update(status: :available)
    assert_equal true, @ad.update(status: :booked)
    assert_equal true, @ad.update(status: :delivered)
    assert_raises(ArgumentError) { @ad.update(status: :other) }
  end

  test 'ad validates maximum length of title' do
    assert @ad.update(title: 'a' * 100)
    assert_not @ad.update(title: 'a' * 101)
  end

  test 'ad validates minimum length of title' do
    assert @ad.update(title: 'a' * 4)
    assert_not @ad.update(title: 'a' * 3)
  end

  test 'ad title escapes privacy data' do
    text = 'por email example@example.com, o whatsapp al 666666666'
    expected_text = 'por email  , o   al  '
    @ad.update!(title: text)
    assert_equal expected_text, @ad.filtered_title
  end

  test 'ad body escapes privacy data' do
    text = 'por email example@example.com, o whatsapp al 666666666'
    expected_text = 'por email  , o   al  '
    @ad.update!(body: text)
    assert_equal expected_text, @ad.filtered_body
  end

  test 'ad validates max length of body' do
    assert @ad.update(body: 'a' * 1000)
    assert_not @ad.update(body: 'a' * 1001)
  end

  test 'ad validates min length of body' do
    assert @ad.update(body: 'a' * 25)
    assert_not @ad.update(body: 'a' * 24)
  end

  test 'ad check slug' do
    assert_equal 'ordenador-en-vallecas', @ad.slug
  end

  test 'ad check type_string' do
    assert_equal 'regalo', @ad.type_string
    @ad.update!(type: :want)
    assert_equal 'petición', @ad.type_string
  end

  test 'ad check status_string' do
    assert_equal 'disponible', @ad.status_string
    @ad.update!(status: :booked)
    assert_equal 'reservado', @ad.status_string
    @ad.update!(status: :delivered)
    assert_equal 'entregado', @ad.status_string
  end

  test 'ad meta_title for give ads' do
    mocking_yahoo_woeid_info(@ad.woeid_code) do
      @ad.update!(type: :give)
      title = 'regalo segunda mano gratis  ordenador en Vallecas Madrid, ' \
              'Madrid, España'
      assert_equal title, @ad.meta_title
    end
  end

  test 'ad meta_title for want ads' do
    skip

    mocking_yahoo_woeid_info(@ad.woeid_code) do
      @ad.update!(type: :want)
      title = 'busco ordenador en Vallecas Madrid, Madrid, España'
      assert_equal title, @ad.meta_title
    end
  end

  test 'ad body shoudl store emoji' do
    skip
    body = 'What a nice emoji😀!What a nice emoji😀!What a nice emoji😀!What a nice emoji😀!What a nice emoji😀!'
    @ad.update!(body: body)
    assert_equal body, @ad.body
  end

  test 'ad bumping refreshes publication date' do
    @ad.published_at = 1.week.ago
    @ad.bump

    assert_in_delta Time.zone.now.to_i, @ad.published_at.to_i, 1
  end

  test 'ad bumping resets readed count' do
    @ad.readed_count = 100
    @ad.bump

    assert_equal 0, @ad.readed_count
  end

  test 'associated comments are deleted when ad is deleted' do
    create(:comment, ad: @ad)

    assert_difference(-> { Comment.count }, -1) { @ad.destroy }
  end

  test '.by_title ignores invalid bytes sequences' do
    assert_equal [], Ad.by_title("Física y Química 3º ESoC3\x93")
  end
end
