# frozen_string_literal: true
class DeleteThreadIdFromMailboxerConversations < ActiveRecord::Migration
  def up
    remove_column :mailboxer_conversations, :thread_id
  end

  def down
    add_column :mailboxer_conversations, :thread_id, :integer, default: 0
  end
end
