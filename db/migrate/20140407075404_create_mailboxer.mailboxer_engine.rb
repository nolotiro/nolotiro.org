# frozen_string_literal: true

# This migration comes from mailboxer_engine (originally 20110511145103)
class CreateMailboxer < ActiveRecord::Migration
  def up
    create_conversations

    create_receipts

    create_notifications

    add_index 'receipts', 'notification_id'

    add_index 'notifications', 'conversation_id'

    add_foreign_key 'receipts', 'notifications', name: 'receipts_on_notification_id'
    add_foreign_key 'notifications', 'conversations', name: 'notifications_on_conversation_id'
  end

  def down
    remove_foreign_key 'receipts', name: 'receipts_on_notification_id'
    remove_foreign_key 'notifications', name: 'notifications_on_conversation_id'

    drop_table :receipts
    drop_table :conversations
    drop_table :notifications
  end

  private

  def create_conversations
    create_table :conversations do |t|
      t.column :subject, :string, default: ''
      t.column :created_at, :datetime, null: false
      t.column :updated_at, :datetime, null: false
    end
  end

  def create_receipts
    create_table :receipts do |t|
      t.references :receiver, polymorphic: true
      t.column :notification_id, :integer, null: false
      t.column :read, :boolean, default: false
      t.column :trashed, :boolean, default: false
      t.column :deleted, :boolean, default: false
      t.column :mailbox_type, :string, limit: 25
      t.column :created_at, :datetime, null: false
      t.column :updated_at, :datetime, null: false
    end
  end

  def create_notifications
    create_table :notifications do |t|
      t.column :type, :string
      t.column :body, :text
      t.column :subject, :string, default: ''
      t.references :sender, polymorphic: true
      t.references :object, polymorphic: true
      t.column :conversation_id, :integer
      t.column :draft, :boolean, default: false
      t.column :updated_at, :datetime, null: false
      t.column :created_at, :datetime, null: false
    end
  end
end
