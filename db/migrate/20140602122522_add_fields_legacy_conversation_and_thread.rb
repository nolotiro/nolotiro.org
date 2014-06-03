class AddFieldsLegacyConversationAndThread < ActiveRecord::Migration
  def change
    add_column :conversations, :thread_id, :integer, :default => 0
    add_column :threads, :conversation_id, :integer, :default => 0
  end
end
