# frozen_string_literal: true

class AddReadedCountDefault < ActiveRecord::Migration
  def up
    change_column_default :ads, :readed_count, 0

    execute 'UPDATE ads SET readed_count = 0 WHERE readed_count IS NULL'
  end

  def down
    change_column_default :ads, :readed_count, nil

    execute 'UPDATE ads SET readed_count = NULL WHERE readed_count = 0'
  end
end
