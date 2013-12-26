class ChangeStatusTypeToAds < ActiveRecord::Migration
  # nolotirov2 legacy DB

  def self.up
    # Change DB column status type from enum to string (VARCHAR)
    #
    #   Field: status
    #   Type: enum('delivered','booked','available')
    #   Null: NO
    #   Key: 
    #   Default: available
    #   Extra: 
    change_column :ads, :status, :string, :default => "available", :null => false

    # Change status data from strings like "available" to integers like "1"
    Ad.unscoped.where(status: "available").update_all(status: "1")
    Ad.unscoped.where(status: "booked").update_all(status: "2")
    Ad.unscoped.where(status: "delivered").update_all(status: "3")

    # Change DB column status type from string (VARCHAR) to integer
    change_column :ads, :status, :integer, :default => 1, :null => false
  end

  def self.down
    change_column :ads, :status, :string, :default => "available"
    Ad.unscoped.where(status: 1).update_all(status: 'available')
    Ad.unscoped.where(status: 2).update_all(status: 'booked')
    Ad.unscoped.where(status: 3).update_all(status: 'delivered')
  end

end
