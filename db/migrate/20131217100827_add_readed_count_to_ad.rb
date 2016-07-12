# frozen_string_literal: true
class AddReadedCountToAd < ActiveRecord::Migration
  def up
    add_column :ads, :readed_count, :integer
  end

  def down
    remove_column :ads, :readed_count, :integer
  end
end
