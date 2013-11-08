class AddAdsCounterToUser < ActiveRecord::Migration

  def self.up
    add_column :users, :ads_count, :integer, :default => 0

    User.reset_column_information
    User.find(:all).each do |u|
      User.update_counters u.id, :ads_count => u.ads.length
    end
  end

  def self.down
    remove_column :users, :ads_count
  end

end
