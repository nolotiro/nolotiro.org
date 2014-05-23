class AddIsMigratedToMessageLegacy < ActiveRecord::Migration
  def change
    add_column :messages_legacy, :is_migrated, :boolean, default: false
  end
end
