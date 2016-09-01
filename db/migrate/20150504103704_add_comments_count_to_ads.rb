# frozen_string_literal: true

class AddCommentsCountToAds < ActiveRecord::Migration
  def up
    add_column :ads, :comments_count, :integer, default: 0

    Ad.reset_column_information
    Ad.all.find_each do |ad|
      ad.comments_count = ad.comments.length
      ad.save
    end
  end

  def down
    remove_column :ads, :comments_count
  end
end
