# frozen_string_literal: true

class ChangeReadedCountDefaultToOne < ActiveRecord::Migration[4.2]
  def up
    change_column_default :ads, :readed_count, 1

    execute 'UPDATE ads SET readed_count = 1 WHERE readed_count = 0'
  end

  def down
    change_column_default :ads, :readed_count, 0

    execute 'UPDATE ads SET readed_count = 0 WHERE readed_count = 1'
  end
end
