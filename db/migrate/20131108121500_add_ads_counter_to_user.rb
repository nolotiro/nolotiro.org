class AddAdsCounterToUser < ActiveRecord::Migration

  def up
    add_column :users, :ads_count, :integer, :default => 0
  end

  def down
    remove_column :users, :ads_count
  end

end
