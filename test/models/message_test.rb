# frozen_string_literal: true
require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  before do
    @sender = FactoryGirl.create(:user)
    @receiver = FactoryGirl.create(:user)
  end

  test 'mailboxer messages are sent' do
    receipt = @sender.send_message(@receiver, 'body', 'subject')
    assert_equal receipt.valid?, true
  end

  test 'mailboxer messages with emojis are sent' do
    skip
    receipt = @sender.send_message(@receiver, 'body', 'subject with emoji 😀')
    assert_equal receipt.valid?, true
  end
end
