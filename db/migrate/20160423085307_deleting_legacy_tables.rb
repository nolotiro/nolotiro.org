class DeletingLegacyTables < ActiveRecord::Migration
  def up
    drop_table :commentsAdCount
    drop_table :messages_deleted
    drop_table :messages_legacy
    drop_table :threads
    drop_table :readedAdCount
  end

  def down
  end
end
