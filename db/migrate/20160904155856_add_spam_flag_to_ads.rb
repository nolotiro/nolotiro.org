# frozen_string_literal: true

class AddSpamFlagToAds < ActiveRecord::Migration
  def change
    add_column :ads, :spam, :boolean, null: false, default: false
  end
end
