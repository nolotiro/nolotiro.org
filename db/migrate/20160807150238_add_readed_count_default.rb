# frozen_string_literal: true

class AddReadedCountDefault < ActiveRecord::Migration
  def up
    change_column_default :ads, :readed_count, 0
  end

  def down
    change_column_default :ads, :readed_count, nil
  end
end
