# frozen_string_literal: true
class ChangeStatusTypeToAds < ActiveRecord::Migration
  # nolotirov2 legacy DB

  def up
    # Change DB column status type from enum to string (VARCHAR)
    #
    #   Field: status
    #   Type: enum('delivered','booked','available')
    #   Null: NO
    #   Key:
    #   Default: available
    #   Extra:
    change_column :ads, :status, :string, default: 'available', null: false

    # Change status data from strings like "available" to integers like "1"
    Ad.where(status: 'available').update_all(status: '1')
    Ad.where(status: 'booked').update_all(status: '2')
    Ad.where(status: 'delivered').update_all(status: '3')

    # Change DB column status type from string (VARCHAR) to integer
    change_column :ads, :status, :integer, default: 1, null: false
  end

  def down
    change_column :ads, :status, :string, default: 'available'
    Ad.where(status: 1).update_all(status: 'available')
    Ad.where(status: 2).update_all(status: 'booked')
    Ad.where(status: 3).update_all(status: 'delivered')
  end
end
