# frozen_string_literal: true

require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  def setup
    super

    @user, @recipient = create_list(:user, 2)

    @conversation = create(:conversation, originator: @user,
                                          recipient: @recipient)
  end

  def test_enforces_non_nil_sender_on_creation
    message = @conversation.messages.build(sender: nil, body: 'hi!')

    assert_equal false, message.valid?
  end

  def test_allows_sender_becoming_orphan
    assert_equal true, @conversation.messages.first.update(sender: nil)
  end

  def test_unread_by_scope_returns_the_number_of_unread_messages
    assert_equal 0, messages.unread_by(@user).size
    assert_equal 1, messages.unread_by(@recipient).size

    @conversation.envelope_for(sender: @user,
                               recipient: @recipient,
                               body: 'You there, buddy?')
    @conversation.save!

    assert_equal 0, messages.unread_by(@user).size
    assert_equal 2, messages.unread_by(@recipient).size
  end

  def test_involving_includes_outgoing_messages
    assert_equal messages.to_set, Message.involving(@user).to_set
  end

  def test_involving_includes_incoming_messages
    @conversation.envelope_for(sender: @recipient, recipient: @user, body: 'hi')
    @conversation.save!

    assert_equal messages.to_set, Message.involving(@user).to_set
  end

  def test_involving_includes_orphan_messages
    @recipient.destroy

    assert_equal messages.to_set, Message.involving(@user).to_set
  end

  private

  def messages
    @conversation.messages
  end
end
