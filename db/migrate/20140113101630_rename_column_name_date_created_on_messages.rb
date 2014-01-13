class RenameColumnNameDateCreatedOnMessages < ActiveRecord::Migration
  def change
    rename_column :messages, :date_created, :created_at
    add_column :messages, :updated_at, :datetime
  end
end
