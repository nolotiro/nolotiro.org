# frozen_string_literal: true

class CreateAntifraudModels < ActiveRecord::Migration[5.1]
  def change
    create_table :antifraud_rules do |t|
      t.text :sentence
      t.datetime :activated_at

      t.timestamps
    end

    create_table :antifraud_matches do |t|
      t.references :antifraud_rule, foreign_key: true
      t.references :ad, foreign_key: true

      t.timestamps
    end
  end
end
