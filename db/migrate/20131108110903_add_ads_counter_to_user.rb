class AddAdsCounterToUser < ActiveRecord::Migration

  def self.up
    add_column :users, :ads_count, :integer, :default => 0

    User.reset_column_information
    User.find_each do |u|
      User.reset_counters u.id, :ads
    end
  end

  def self.down
    remove_column :users, :ads_count
  end

end
