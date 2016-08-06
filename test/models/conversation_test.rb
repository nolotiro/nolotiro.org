# frozen_string_literal: true

require 'test_helper'

class ConversationTest < ActiveSupport::TestCase
  def setup
    super

    @user, @recipient = create_list(:user, 2)

    @conversation = create(:conversation, originator: @user,
                                          recipient: @recipient)
  end

  def test_unread_scope_returns_unread_conversations_only
    assert_equal 0, Conversation.unread(@user).size
    assert_equal 1, Conversation.unread(@recipient).size
  end

  def test_mark_as_read_does_what_its_name_indicates
    @conversation.mark_as_read(@recipient)

    assert_equal 0, Conversation.unread(@user).size
    assert_equal 0, Conversation.unread(@recipient).size
  end

  def test_unread_scope_excludes_deleted_conversations
    @conversation.move_to_trash(@recipient)

    assert_equal 0, Conversation.unread(@user).size
    assert_equal 0, Conversation.unread(@recipient).size
  end

  def test_unread_method_returns_a_boolean_unread_flag
    assert_equal false, @conversation.unread?(@user)
    assert_equal true, @conversation.unread?(@recipient)
  end
end
