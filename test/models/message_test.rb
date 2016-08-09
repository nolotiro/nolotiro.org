# frozen_string_literal: true

require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  def setup
    super

    @user, @recipient = create_list(:user, 2)

    @conversation = create(:conversation, originator: @user,
                                          recipient: @recipient)
  end

  def test_unread_scope_returns_the_number_of_unread_messages
    assert_equal 0, messages.unread(@user).size
    assert_equal 1, messages.unread(@recipient).size

    @conversation.envelope_for(sender: @user,
                               recipient: @recipient,
                               body: 'You there, buddy?')
    @conversation.save!

    assert_equal 0, messages.unread(@user).size
    assert_equal 2, messages.unread(@recipient).size
  end

  private

  def messages
    @conversation.messages
  end
end
