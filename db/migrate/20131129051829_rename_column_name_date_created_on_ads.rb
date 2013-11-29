class RenameColumnNameDateCreatedOnAds < ActiveRecord::Migration
  def change
    rename_column :ads, :date_created, :created_at
    add_column :ads, :updated_at, :datetime
  end
end
