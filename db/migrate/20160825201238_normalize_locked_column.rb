# frozen_string_literal: true

class NormalizeLockedColumn < ActiveRecord::Migration[5.1]
  def up
    execute 'UPDATE users SET locked = 0 WHERE locked IS NULL'

    change_column_default :users, :locked, 0
    change_column_null :users, :locked, false
  end

  def down
    change_column_null :users, :locked, true
    change_column_default :users, :locked, nil

    execute 'UPDATE users SET locked = NULL WHERE locked = 0'
  end
end
