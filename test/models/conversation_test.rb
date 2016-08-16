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

  def test_unread_excludes_conversations_with_blockers
    create(:blocking, blocker: @user, blocked: @recipient)

    assert_equal 0, Conversation.unread(@user).size
  end

  def test_unread_method_returns_a_boolean_unread_flag
    assert_equal false, @conversation.unread?(@user)
    assert_equal true, @conversation.unread?(@recipient)
  end

  def test_envelope_for_touches_the_conversation_timestamp
    @conversation.update!(updated_at: 1.hour.ago)
    @conversation.envelope_for(sender: @user, recipient: @recipient)

    assert_in_delta @conversation.updated_at, Time.zone.now, 1.second
  end

  def test_involving_lists_conversations_with_users_not_blocking_a_user
    other = create(:user)
    other_conversation = create(:conversation, originator: other,
                                               recipient: @user)

    assert_equal [@conversation, other_conversation],
                 Conversation.involving(@user)

    create(:blocking, blocker: @recipient, blocked: @user)
    assert_equal [other_conversation], Conversation.involving(@user)

    create(:blocking, blocker: other, blocked: @user)
    assert_empty Conversation.involving(@user)
  end

  def test_involving_includes_orphan_conversations
    @recipient.destroy

    assert_equal [@conversation], Conversation.involving(@user)
  end

  def test_involving_excludes_deleted_conversations
    @conversation.move_to_trash(@user)

    assert_empty Conversation.involving(@user)
  end

  def test_interlocutor_returns_nil_for_orphan_conversations
    @recipient.destroy

    assert_nil @conversation.interlocutor(@user)
  end
end
