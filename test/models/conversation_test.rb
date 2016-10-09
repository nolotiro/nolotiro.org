# frozen_string_literal: true

require 'test_helper'

class ConversationTest < ActiveSupport::TestCase
  def setup
    super

    @user, @recipient = create_list(:user, 2)

    @conversation = create(:conversation, originator: @user,
                                          recipient: @recipient)
  end

  def test_unread_by_scope_returns_unread_conversations_only
    assert_equal 0, Conversation.unread_by(@user).size
    assert_equal 1, Conversation.unread_by(@recipient).size

    @conversation.mark_as_read(@recipient)

    assert_equal 0, Conversation.unread_by(@user).size
    assert_equal 0, Conversation.unread_by(@recipient).size
  end

  def test_unread_by_scope_excludes_deleted_conversations
    @conversation.move_to_trash(@recipient)

    assert_equal 0, Conversation.unread_by(@user).size
    assert_equal 0, Conversation.unread_by(@recipient).size
  end

  def test_unread_by_scope_returns_unique_conversations
    @conversation.reply(sender: @user, recipient: @recipient, body: 'Nice!')
    @conversation.save!

    assert_equal 1, Conversation.unread_by(@recipient).size
  end

  def test_whitelisted_for_scope_excludes_conversations_with_blockers
    create(:blocking, blocker: @user, blocked: @recipient)

    assert_equal 1, Conversation.whitelisted_for(@user).size
    assert_equal 0, Conversation.whitelisted_for(@recipient).size
  end

  def test_with_legitimate_participants_excludes_stuff_with_banned_originators
    assert_equal 1, Conversation.with_legitimate_participants.size

    assert_difference(-> { Conversation.with_legitimate_participants.size }, -1) do
      @user.ban!
    end
  end

  def test_with_legitimate_participants_excludes_stuff_with_banned_recipients
    assert_equal 1, Conversation.with_legitimate_participants.size

    assert_difference(-> { Conversation.with_legitimate_participants.size }, -1) do
      @recipient.ban!
    end
  end

  def test_untrashed_by_scope_returns_untrashed_conversations_only
    assert_equal 1, Conversation.untrashed_by(@user).size
    assert_equal 1, Conversation.untrashed_by(@recipient).size

    @conversation.move_to_trash(@user)

    assert_equal 0, Conversation.untrashed_by(@user).size
    assert_equal 1, Conversation.untrashed_by(@recipient).size
  end

  def test_untrashed_by_scope_returns_unique_conversations
    @conversation.reply(sender: @user, recipient: @recipient, body: 'Nice!')
    @conversation.save!
    @conversation.move_to_trash(@recipient)

    assert_equal 1, Conversation.untrashed_by(@user).size
  end

  def test_reply_touches_the_conversation_timestamp
    @conversation.update!(updated_at: 1.hour.ago)
    @conversation.reply(sender: @user, recipient: @recipient, body: 'Hey!')

    assert_in_delta @conversation.updated_at, Time.zone.now, 1.second
  end

  def test_interlocutor_returns_nil_for_orphan_conversations_w_one_msg
    @recipient.destroy

    assert_nil @conversation.reload.interlocutor(@user)
  end

  def test_interlocutor_returns_nil_for_orphan_conversations_w_several_msgs
    @conversation.reply(sender: @recipient, recipient: @user, body: 'Hei!')
    @conversation.save!

    @recipient.destroy
    assert_nil @conversation.reload.interlocutor(@user)
  end

  def test_interlocutor_returns_nil_for_orphan_conversations_w_several_sent_msgs
    @conversation.reply(sender: @user, recipient: @recipient, body: 'Hei!')
    @conversation.save!

    @recipient.destroy
    assert_nil @conversation.reload.interlocutor(@user)
  end

  def test_recipient_when_she_has_sent_messages_and_originator_no_longer_there
    @conversation.reply(sender: @recipient, recipient: @user, body: 'Hei!')
    @conversation.save!

    @user.destroy

    assert_equal @recipient, @conversation.reload.recipient
  end

  def test_recipient_when_no_sent_messages_and_originator_no_longer_there
    @user.destroy

    assert_equal @recipient, @conversation.reload.recipient
  end

  def test_messages_for_are_ordered_most_recent_last
    @conversation.reply(sender: @user, recipient: @recipient, body: 'Hei!')
    @conversation.save!

    assert_equal 'Hei!', @conversation.messages_for(@user)[1].body
  end
end
