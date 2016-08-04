# frozen_string_literal: true

class UniqueIndexForUsernameColumn < ActiveRecord::Migration
  def change
    add_index :users, :username, unique: true
  end
end
