# frozen_string_literal: true

class RemoveOrphanAds < ActiveRecord::Migration
  def change
    reversible do |direction|
      direction.up do
        execute 'DELETE FROM ads WHERE user_owner NOT IN (SELECT id from users)'
      end
    end

    add_index :ads, :user_owner
    add_foreign_key :ads, :users, column: :user_owner
  end
end
