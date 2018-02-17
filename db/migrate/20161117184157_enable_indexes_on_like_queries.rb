# frozen_string_literal: true

class EnableIndexesOnLikeQueries < ActiveRecord::Migration[5.1]
  def up
    unless extension_enabled?("pg_trgm")
      raise <<-MSG.squish
        You must enable the pg_trgm extension. You can do so by running
        "CREATE EXTENSION pg_trgm;" on the current DB as a PostgreSQL
        super user.
      MSG
    end

    %w[towns states countries].each do |table|
      execute <<-SQL.squish
        CREATE INDEX index_#{table}_on_name_trigram
        ON #{table}
        USING gin(name gin_trgm_ops)
      SQL
    end
  end

  def down
    %i[towns states countries].each do |table|
      remove_index table, name: :"index_#{table}_on_name_trigram"
    end
  end
end
