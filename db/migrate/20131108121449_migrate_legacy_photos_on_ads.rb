class MigrateLegacyPhotosOnAds < ActiveRecord::Migration
  def up

    # For all Ads if they have photo we are going to the original photo file and 
    # save it as image; the photo attribute after the conversion is nil 
    Ad.all.find_each do |ad|
      if ad.photo? and ad.image_file_name.nil?
        filename = Rails.root.to_s + '/public/legacy/uploads/ads/original/' + ad.photo
        if File.file?(filename)
          file = File.new(filename, "r")
          ad.image = file
          ad.photo = nil
          ad.save
          file.close
        end
      end
    end
  end

  def down
  end
end
