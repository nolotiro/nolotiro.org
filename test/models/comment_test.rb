# frozen_string_literal: true

require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  test 'comment requires everything' do
    c = Comment.new
    c.valid?
    assert c.errors[:ads_id].include?('no puede estar en blanco')
    assert c.errors[:body].include?('no puede estar en blanco')
    assert c.errors[:user_owner].include?('no puede estar en blanco')
    assert c.errors[:ip].include?('no puede estar en blanco')
  end

  test 'comment escaped body with escape_privacy_data' do
    comment = Comment.new
    text = 'contactar por email example@example.com, por sms 999999999, o whatsapp al 666666666'
    expected_text = 'contactar por email  , por sms  , o   al  '
    comment.body = text
    assert_equal(comment.body, expected_text)
  end
end
