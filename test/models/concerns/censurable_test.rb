# frozen_string_literal: true

require 'test_helper'

class CensurableTest < ActiveSupport::TestCase
  include Censurable

  def test_escape_privacy_data
    text = 'si hay interés, por favor, contactar por email ' \
           'example@example.com, por sms 999999999, o whatsapp al 666666666'

    expected_text = 'si hay interés, por favor, contactar por email  , por ' \
                    'sms  , o   al  '

    assert_equal expected_text, escape_privacy_data(text)
  end
end
