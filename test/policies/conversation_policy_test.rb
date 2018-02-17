# frozen_string_literal: true

require "test_helper"
require "policies/concerns/policy_helper"

class ConversationPolicyTest < ActiveSupport::TestCase
  include PolicyHelper

  def setup
    super

    @user, @recipient = create_list(:user, 2)

    @conversation = create(:conversation, originator: @user,
                                          recipient: @recipient)
  end

  def test_conversation_lists_exclude_blockers
    other_user = create(:user)
    other = create(:conversation, originator: other_user, recipient: @user)

    assert_permit_index(@user, @conversation)
    assert_permit_index(@user, other)

    create(:blocking, blocker: @recipient, blocked: @user)
    refute_permit_index(@user, @conversation)
    assert_permit_index(@user, other)

    create(:blocking, blocker: other_user, blocked: @user)
    refute_permit_index(@user, @conversation)
    refute_permit_index(@user, other)
  end

  def test_conversation_lists_include_orphan_conversations
    @recipient.destroy

    assert_permit_index(@user, @conversation)
  end

  def test_conversation_lists_exclude_deleted_conversations
    @conversation.move_to_trash(@user)

    refute_permit_index(@user, @conversation)
  end

  def test_conversation_lists_include_started_conversations
    assert_permit_index(@user, @conversation)
  end

  def test_conversation_lists_include_received_conversations
    @conversation.update!(originator: @recipient, recipient: @user)

    assert_permit_index(@user, @conversation)
  end

  def test_conversation_lists_exclude_started_conversations_with_blockers
    create(:blocking, blocker: @recipient, blocked: @user)

    refute_permit_index(@user, @conversation)
  end

  def test_conversation_lists_include_started_conversations_with_blocked_users
    create(:blocking, blocker: @user, blocked: @recipient)

    assert_permit_index(@user, @conversation)
  end

  def test_conversation_lists_exclude_received_conversations_with_blockers
    @conversation.update!(originator: @recipient, recipient: @user)
    create(:blocking, blocker: @recipient, blocked: @user)

    refute_permit_index(@user, @conversation)
  end

  def test_conversation_lists_include_received_conversations_with_blocked_users
    @conversation.update!(originator: @recipient, recipient: @user)
    create(:blocking, blocker: @user, blocked: @recipient)

    assert_permit_index(@user, @conversation)
  end

  def test_conversation_lists_include_started_conversations_with_deleted_users
    @recipient.destroy

    assert_permit_index(@user, @conversation)
  end

  def test_conversation_lists_include_received_conversations_with_deleted_users
    @conversation.update!(originator: @recipient, recipient: @user)
    @recipient.destroy

    assert_permit_index(@user, @conversation)
  end
end
