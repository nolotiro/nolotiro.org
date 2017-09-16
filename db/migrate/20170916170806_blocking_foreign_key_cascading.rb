# frozen_string_literal: true

#
# Changes blockings foreign keys to delete in cascade.
#
class BlockingForeignKeyCascading < ActiveRecord::Migration[5.1]
  def up
    remove_foreign_key :blockings, column: :blocked_id
    add_foreign_key :blockings, :users, column: :blocked_id, on_delete: :cascade

    remove_foreign_key :blockings, column: :blocker_id
    add_foreign_key :blockings, :users, column: :blocker_id, on_delete: :cascade
  end

  def down
    remove_foreign_key :blockings, column: :blocker_id
    add_foreign_key :blockings, :users, column: :blocker_id, on_delete: :restrict

    remove_foreign_key :blockings, column: :blocked_id
    add_foreign_key :blockings, :users, column: :blocked_id, on_delete: :restrict
  end
end
