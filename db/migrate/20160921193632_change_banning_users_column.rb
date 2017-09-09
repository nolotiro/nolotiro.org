# frozen_string_literal: true

class ChangeBanningUsersColumn < ActiveRecord::Migration[5.1]
  def up
    add_column :users, :banned_at, :datetime

    execute <<-SQL.squish
      UPDATE users SET banned_at = '#{Time.zone.now.to_s(:db)}' WHERE locked = 1
    SQL
  end

  def down
    execute 'UPDATE users SET locked = 1 WHERE banned_at IS NOT NULL'

    remove_column :users, :banned_at
  end
end
