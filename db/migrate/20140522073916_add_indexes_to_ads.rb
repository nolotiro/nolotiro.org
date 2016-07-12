# frozen_string_literal: true
class AddIndexesToAds < ActiveRecord::Migration
  def change
    add_index :ads, :deleted_at
    add_index :ads, :status
  end
end
