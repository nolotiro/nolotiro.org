# frozen_string_literal: true

# This migration comes from mailboxer_engine (originally 20111204163911)
class AddAttachments < ActiveRecord::Migration
  def up
    add_column :notifications, :attachment, :string
  end

  def down
    remove_column :notifications, :attachment
  end
end
