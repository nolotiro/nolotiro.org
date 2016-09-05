# frozen_string_literal: true

class AddAttachmentImageToAds < ActiveRecord::Migration
  def up
    change_table :ads do |t|
      t.attachment :image
    end
  end

  def down
    drop_attached_file :ads, :image
  end
end
