class AdCommentsIntegrity < ActiveRecord::Migration
  def change
    reversible do |direction|
      direction.up do
        execute <<-SQL.squish
          DELETE c FROM comments c
          LEFT JOIN ads a
          ON c.ads_id = a.id
          WHERE a.id IS NULL
        SQL
      end
    end

    add_foreign_key :comments, :ads, column: :ads_id
  end
end
