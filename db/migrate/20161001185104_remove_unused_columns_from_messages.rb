# frozen_string_literal: true

class RemoveUnusedColumnsFromMessages < ActiveRecord::Migration[4.2]
  def up
    remove_column :messages, :draft, :boolean, default: false
    remove_column :messages, :notification_code, :string, limit: 255
    remove_column :messages, :attachment, :string, limit: 255
    remove_column :messages, :global, :boolean, default: false
    remove_column :messages, :expires, :datetime
  end

  def down
    add_column :messages, :draft, :boolean, default: false
    add_column :messages, :notification_code, :string, limit: 255
    add_column :messages, :attachment, :string, limit: 255
    add_column :messages, :global, :boolean, default: false
    add_column :messages, :expires, :datetime
  end
end
