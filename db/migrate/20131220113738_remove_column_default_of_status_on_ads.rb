# frozen_string_literal: true

class RemoveColumnDefaultOfStatusOnAds < ActiveRecord::Migration
  def change
    change_column_default(:ads, :status, nil)
  end
end
