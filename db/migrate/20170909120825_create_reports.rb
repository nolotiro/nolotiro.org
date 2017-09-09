# frozen_string_literal: true

#
# Reports table, indexes and foreign keys
#
class CreateReports < ActiveRecord::Migration[5.1]
  def change
    create_table :reports do |t|
      t.integer :reported_id, index: true
      t.integer :reporter_id, index: true
      t.datetime :dismissed_at
      t.datetime :created_at, null: false
    end

    add_foreign_key :reports, :users, column: :reporter_id
    add_foreign_key :reports, :users, column: :reported_id
  end
end
