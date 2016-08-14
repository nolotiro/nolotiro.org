# frozen_string_literal: true

class RemoveCommentsCounterCache < ActiveRecord::Migration
  def change
    remove_column :ads, :comments_count, :integer, default: 0
  end
end
