class RemoveDefaultWoeid < ActiveRecord::Migration
  def up
    change_column_null :users, :woeid, true
    change_column_default :users, :woeid, nil
  end

  def down
    change_column_default :users, :woeid, 766_273
    change_column_null :users, :woeid, false
  end
end
