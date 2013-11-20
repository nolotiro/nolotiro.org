class ChangeLockedOnUsers < ActiveRecord::Migration
  def change
    change_column :users, :locked, :integer, :null=>true
  end
end
