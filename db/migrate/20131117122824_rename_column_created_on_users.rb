# frozen_string_literal: true

class RenameColumnCreatedOnUsers < ActiveRecord::Migration
  def change
    rename_column('users', 'created', 'created_at')
  end
end
