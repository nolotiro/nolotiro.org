class RenameColumnNameDateCreatedOnComments < ActiveRecord::Migration
  def change
    rename_column :comments, :date_created, :created_at
    add_column :comments, :updated_at, :datetime
  end
end
