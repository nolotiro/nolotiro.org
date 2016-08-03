# frozen_string_literal: true

class RenameMailboxerTables < ActiveRecord::Migration
  def change
    rename_table :mailboxer_receipts, :receipts
    rename_table :mailboxer_notifications, :messages
    rename_table :mailboxer_conversations, :conversations

    rename_index :messages,
                 :index_mailboxer_notifications_on_notified_object_id_and_type,
                 :index_messages_on_notified_object_id_and_type
  end
end
