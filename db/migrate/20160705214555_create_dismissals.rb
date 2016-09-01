# frozen_string_literal: true

class CreateDismissals < ActiveRecord::Migration
  def change
    create_table :dismissals do |t|
      t.references :announcement, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
    end
  end
end
