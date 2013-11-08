class AddAttachmentImageToAds < ActiveRecord::Migration
  def self.up
    change_table :ads do |t|
      t.attachment :image
    end
  end

  def self.down
    drop_attached_file :ads, :image
  end
end
