# frozen_string_literal: true

#
# @note This migration will be the first migration and will contain an initial
# schema of the DB. For now, it just prunes migration older that itself from
# DB.
#
class PruneOldInvalidMigrations < ActiveRecord::Migration
  def up
    execute "DELETE FROM schema_migrations WHERE VERSION < '20160803173909'"
  end

  def down
    # Do nothing
  end
end
