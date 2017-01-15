# frozen_string_literal: true

require 'test_helper'

class CensurableTestPost < ActiveRecord::Base
  include Censurable
  censors :title
end

class CensurableTest < ActiveSupport::TestCase
  before do
    ActiveRecord::Migration.suppress_messages do
      ActiveRecord::Migration.create_table :censurable_test_posts do |t|
        t.string :title
      end
    end
  end

  after do
    ActiveRecord::Migration.suppress_messages do
      ActiveRecord::Migration.drop_table :censurable_test_posts
    end
  end

  def test_defines_method_for_attribute_censoring
    text = 'si hay interés, por favor, contactar por email ' \
           'example@example.com, por sms 999999999, o whatsapp al 666666666'

    expected_text = <<-TXT.squish
      si hay interés, por favor, contactar por email [INFORMACIÓN PRIVADA
      OCULTA], por sms [INFORMACIÓN PRIVADA OCULTA], o [INFORMACIÓN PRIVADA
      OCULTA] al [INFORMACIÓN PRIVADA OCULTA]
    TXT

    assert_equal expected_text,
                 CensurableTestPost.new(title: text).filtered_title
  end
end
