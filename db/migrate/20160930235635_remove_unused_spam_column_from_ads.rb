# frozen_string_literal: true

class RemoveUnusedSpamColumnFromAds < ActiveRecord::Migration
  def change
    remove_column :ads, :spam, :boolean, default: false, null: false
  end
end
