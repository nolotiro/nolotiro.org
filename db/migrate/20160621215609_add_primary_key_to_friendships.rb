# frozen_string_literal: true
class AddPrimaryKeyToFriendships < ActiveRecord::Migration
  def change
    add_column :friendships, :id, :primary_key
  end
end
