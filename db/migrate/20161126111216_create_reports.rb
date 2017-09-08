# frozen_string_literal: true

class CreateReports < ActiveRecord::Migration[5.1]
  def change
    create_table :reports do |t|
      t.integer :ad_id, index: true
      t.integer :reporter_id, index: true
      t.integer :reason
      t.datetime :created_at, null: false
    end

    add_foreign_key :reports, :ads
    add_foreign_key :reports, :users, column: :reporter_id
  end
end
