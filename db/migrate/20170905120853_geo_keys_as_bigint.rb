# frozen_string_literal: true

class GeoKeysAsBigint < ActiveRecord::Migration[5.1]
  def up
    change_column :countries, :id, :bigint
    change_column :states, :id, :bigint
    change_column :towns, :id, :bigint

    change_column :states, :country_id, :bigint
    change_column :towns, :state_id, :bigint
    change_column :towns, :country_id, :bigint
  end

  def down
    change_column :towns, :country_id, :integer
    change_column :towns, :state_id, :integer
    change_column :states, :country_id, :integer

    change_column :towns, :id, :integer
    change_column :states, :id, :integer
    change_column :countries, :id, :integer
  end
end
