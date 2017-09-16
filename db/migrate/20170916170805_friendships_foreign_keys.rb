# frozen_string_literal: true

#
# Adds foreign keys that ensure data integrity at the DB level to friendships,
# and fixes current data integrity issues.
#
class FriendshipsForeignKeys < ActiveRecord::Migration[5.1]
  def up
    %w[friend_id user_id].each { |col| remove_orphan_friendships(col) }

    add_foreign_key :friendships, :users, column: :friend_id, on_delete: :cascade
    add_foreign_key :friendships, :users, column: :user_id, on_delete: :cascade
  end

  def down
    remove_foreign_key :friendships, column: :user_id
    remove_foreign_key :friendships, column: :friend_id
  end

  private

  def remove_orphan_friendships(column)
    execute <<-SQL.squish
      DELETE FROM friendships
      WHERE id IN (
        SELECT f.id
        FROM friendships f
        LEFT OUTER JOIN users u
        ON f.#{column} = u.id
        WHERE u.id IS NULL
      )
    SQL
  end
end
