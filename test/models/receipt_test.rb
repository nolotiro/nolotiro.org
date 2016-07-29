# frozen_string_literal: true

require 'test_helper'

class ReceiptTest < ActiveSupport::TestCase
  def setup
    super

    @user, @other = create_list(:user, 2)
  end

  def test_involving_includes_sent_receipts
    create(:message, sender: @user, recipient: @other)

    assert_correctness Receipt.involving(@user)
  end

  def test_involving_includes_received_receipts
    create(:message, sender: @other, recipient: @user)

    assert_correctness Receipt.involving(@user)
  end

  def test_involving_excludes_sent_receipts_related_to_blockers
    create(:message, sender: @user, recipient: @other)
    create(:blocking, blocker: @other, blocked: @user)

    assert_empty Receipt.involving(@user)
  end

  def test_involving_includes_sent_receipts_related_to_blocked_users
    create(:message, sender: @user, recipient: @other)
    create(:blocking, blocker: @user, blocked: @other)

    assert_correctness Receipt.involving(@user)
  end

  def test_involving_excludes_received_receipts_related_to_blockers
    create(:message, sender: @other, recipient: @user)
    create(:blocking, blocker: @other, blocked: @user)

    assert_empty Receipt.involving(@user)
  end

  def test_involving_includes_received_receipts_related_to_blocked_users
    create(:message, sender: @other, recipient: @user)
    create(:blocking, blocker: @user, blocked: @other)

    assert_correctness Receipt.involving(@user)
  end

  def test_involving_includes_receipts_related_to_orphan_users
    create(:message, sender: @other, recipient: @user)
    @other.destroy

    assert_correctness Receipt.involving(@user)
  end

  private

  def assert_correctness(receipts)
    assert_equal 1, receipts.size
    assert_equal @user, receipts.first.receiver
  end
end
