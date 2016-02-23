class AddPublishedAtToAds < ActiveRecord::Migration
  def change
    add_column :ads, :published_at, :datetime, null: false

    reversible do
      execute "UPDATE ads SET published_at = created_at"
    end
  end
end
