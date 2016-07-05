# frozen_string_literal: true
require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase

  test 'should escape_privacy_data' do 
    text = 'si hay interés, por favor, contactar por email example@example.com, por sms 999999999, o whatsapp al 666666666'
    expected_text = 'si hay interés, por favor, contactar por email  , por sms  , o   al  '
    assert_equal(escape_privacy_data(text), expected_text)
  end

  test 'should i18n_to_localeapp_in_locale, :en' do
    assert_equal 20647, i18n_to_localeapp_in_locale(:en)
  end

  test 'should i18n_to_localeapp_in_locale, :nl' do
    assert_equal 24068, i18n_to_localeapp_in_locale(:nl)
  end

  test 'should i18n_to_localeapp_in_locale, :de' do
    assert_equal 20645, i18n_to_localeapp_in_locale(:de)
  end

  test 'should i18n_to_localeapp_in_locale, :it' do
    assert_equal 20649, i18n_to_localeapp_in_locale(:it)
  end
end
