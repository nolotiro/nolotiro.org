# frozen_string_literal: true

class AddOriginatorIdAndRecipientIdToConversations < ActiveRecord::Migration
  def change
    add_column :conversations, :originator_id, :integer
    add_column :conversations, :recipient_id, :integer

    add_index :conversations, :originator_id
    add_index :conversations, :recipient_id
  end
end
