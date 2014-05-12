class AddAdsCounterToUser < ActiveRecord::Migration

  def self.up
    add_column :users, :ads_count, :integer, :default => 0
  end

  def self.down
    remove_column :users, :ads_count
  end

end
