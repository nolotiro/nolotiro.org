# frozen_string_literal: true

class RemoveLangFromUsers < ActiveRecord::Migration[4.2]
  def up
    remove_column :users, :lang, :string, limit: 4, null: false
  end

  def down
    add_column :users, :lang, :string, limit: 4

    execute "UPDATE users SET lang = 'es'"

    change_column_null :users, :lang, false
  end
end
