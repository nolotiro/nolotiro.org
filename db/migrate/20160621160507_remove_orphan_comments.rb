class RemoveOrphanComments < ActiveRecord::Migration
  def change
    reversible do |direction|
      direction.up do
        execute <<-SQL.squish
          DELETE FROM comments WHERE user_owner NOT IN (SELECT id from users)
        SQL
      end
    end

    add_index :comments, :user_owner
    add_foreign_key :comments, :users, column: :user_owner
  end
end
