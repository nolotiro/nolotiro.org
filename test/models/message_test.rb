# frozen_string_literal: true
require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  test 'mailboxer messages are sent' do
    sender = FactoryGirl.create(:user)
    receiver = FactoryGirl.create(:user)
    receipt = sender.send_message(receiver, 'body', 'subject')
    assert_equal receipt.valid?, true
  end
end
