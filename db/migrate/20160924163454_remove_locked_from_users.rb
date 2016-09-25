# frozen_string_literal: true

class RemoveLockedFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :locked, :integer, limit: 4, default: 0, null: false
  end
end
