# frozen_string_literal: true

class RemoveTypeColumnFromMessages < ActiveRecord::Migration
  def up
    remove_index :mailboxer_notifications, :type

    remove_column :mailboxer_notifications, :type, :string
  end

  def down
    add_column :mailboxer_notifications, :type, :string

    add_index :mailboxer_notifications, :type
  end
end
