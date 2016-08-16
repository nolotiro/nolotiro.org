# frozen_string_literal: true

class RemoveUnusedMessagingColumns < ActiveRecord::Migration
  def change
    remove_column :messages, :sender_type, :string

    rename_index :messages,
                 :index_messages_on_sender_id_and_sender_type,
                 :index_messages_on_sender_id

    remove_column :messages, :notified_object_type, :string
    remove_column :messages, :notified_object_id, :integer

    remove_column :receipts, :receiver_type, :string

    rename_index :receipts,
                 :index_receipts_on_receiver_id_and_receiver_type,
                 :index_receipts_on_receiver_id
  end
end
