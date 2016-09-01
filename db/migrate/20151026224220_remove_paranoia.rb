# frozen_string_literal: true

class RemoveParanoia < ActiveRecord::Migration
  def up
    execute <<-SQL
      DELETE FROM ads WHERE deleted_at IS NOT NULL
    SQL

    remove_column :ads, :deleted_at
  end

  def down
    add_column :ads, :deleted_at, :datetime
  end
end
