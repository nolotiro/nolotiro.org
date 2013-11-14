class ChangeStatusTypeToAds < ActiveRecord::Migration
  def self.up
    Ad.update_all({:status => 1}, {:status => "available"})
    Ad.update_all({:status => 2}, {:status => "booked"})
    Ad.update_all({:status => 3}, {:status => "delivered"})
    change_column :ads, :status, :integer, :default => 1
  end

  def self.down
    change_column :ads, :status, :string, :default => "available"
    Ad.update_all({:status => 'available'}, {:status => 1})
    Ad.update_all({:status => 'booked'}, {:status => 2})
    Ad.update_all({:status => 'delivered'}, {:status => 3})
  end
end
