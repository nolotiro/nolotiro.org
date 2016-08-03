# frozen_string_literal: true

class RemoveUnusedMailboxerConversationOptOuts < ActiveRecord::Migration
  def up
    drop_table :mailboxer_conversation_opt_outs
  end

  def down
    create_table :mailboxer_conversation_opt_outs do |t|
      t.integer :unsubscriber_id
      t.string :unsubscriber_type
      t.integer :conversation_id
    end
  end
end
