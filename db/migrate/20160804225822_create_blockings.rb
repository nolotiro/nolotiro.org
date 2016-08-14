# frozen_string_literal: true
class CreateBlockings < ActiveRecord::Migration
  def up
    create_table :blockings do |t|
      t.integer :blocker_id, null: false
      t.integer :blocked_id, null: false
    end

    add_foreign_key :blockings, :users, column: :blocker_id
    add_foreign_key :blockings, :users, column: :blocked_id
  end

  def down
    remove_foreign_key :blockings, column: :blocked_id
    remove_foreign_key :blockings, column: :blocker_id

    drop_table :blockings
  end
end
