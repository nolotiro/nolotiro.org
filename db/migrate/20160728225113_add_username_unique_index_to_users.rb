# frozen_string_literal: true

class AddUsernameUniqueIndexToUsers < ActiveRecord::Migration
  def change
    add_index :users, :username, unique: true
  end
end
