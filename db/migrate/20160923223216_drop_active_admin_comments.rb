# frozen_string_literal: true

class DropActiveAdminComments < ActiveRecord::Migration
  def up
    drop_table :active_admin_comments
  end

  def down
    create_table :active_admin_comments do |t|
      t.string :namespace, index: true
      t.text :body
      t.string :resource_id, null: false
      t.string :resource_type, null: false
      t.integer :author_id
      t.string :author_type
      t.datetime :created_at
      t.datetime :updated_at
    end

    add_index :active_admin_comments, [:author_type, :author_id]
    add_index :active_admin_comments, [:resource_type, :resource_id]
  end
end
