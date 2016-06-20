class LargerUsernames < ActiveRecord::Migration
  def up
    change_column :users, :username, :string, limit: 63
  end

  def down
    change_column :users, :username, :string, limit: 32
  end
end
