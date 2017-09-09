# frozen_string_literal: true

class AddSpamFlagToAds < ActiveRecord::Migration[5.1]
  def change
    add_column :ads, :spam, :boolean, null: false, default: false
  end
end
