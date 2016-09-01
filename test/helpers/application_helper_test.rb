# frozen_string_literal: true

require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test 'should escape_privacy_data' do
    text = 'si hay interés, por favor, contactar por email example@example.com, por sms 999999999, o whatsapp al 666666666'
    expected_text = 'si hay interés, por favor, contactar por email  , por sms  , o   al  '
    assert_equal(escape_privacy_data(text), expected_text)
  end
end
