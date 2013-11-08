class MigrateLegacyPhotosOnAds < ActiveRecord::Migration
  def up
    Ad.all.each do |ad|
      filename = Rails.root.to_s + '/public/legacy/uploads/ads/original/' + ad.photo
      ad.image = File.new(filename, "r")
      ad.save
    end
  end

  def down
  end
end
