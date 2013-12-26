class AddDeletedAtToAds < ActiveRecord::Migration
  def change
    add_column :ads, :deleted_at, :datetime
  end
end
