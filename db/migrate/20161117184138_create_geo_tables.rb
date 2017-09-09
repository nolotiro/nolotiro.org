# frozen_string_literal: true

class CreateGeoTables < ActiveRecord::Migration[5.1]
  def change
    create_table :countries do |t|
      t.string :iso, limit: 2, null: false
      t.string :name, limit: 173, null: false
    end

    create_table :states do |t|
      t.string :name, limit: 173, null: false
      t.references :country, index: true, foreign_key: true, null: false
    end

    create_table :towns do |t|
      t.string :name, limit: 173, null: false
      t.references :state, index: true, foreign_key: true
      t.references :country, index: true, foreign_key: true, null: false
    end
  end
end
