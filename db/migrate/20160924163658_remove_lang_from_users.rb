# frozen_string_literal: true

class RemoveLangFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :lang, :string, limit: 4, null: false
  end
end
