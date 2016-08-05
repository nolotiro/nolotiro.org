# frozen_string_literal: true

class RemoveUnusedMailboxerConversationOptOuts < ActiveRecord::Migration
  def up
    drop_table :mailboxer_conversation_opt_outs
  end

  def down
    create_table :mailboxer_conversation_opt_outs do |t|
      t.integer :unsubscriber_id
      t.string :unsubscriber_type
      t.integer :conversation_id, index: true
    end

    add_index :mailboxer_conversation_opt_outs,
              [:unsubscriber_id, :unsubscriber_type],
              name: 'index_mailboxer_conversation_opt_outs_on_unsubscriber_id_type'

    add_foreign_key :mailboxer_conversation_opt_outs,
                    :conversations,
                    name: 'mb_opt_outs_on_conversations_id'
  end
end
