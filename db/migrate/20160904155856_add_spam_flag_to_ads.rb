# frozen_string_literal: true

class AddSpamFlagToAds < ActiveRecord::Migration[4.2]
  def change
    add_column :ads, :spam, :boolean, null: false, default: false
  end
end
