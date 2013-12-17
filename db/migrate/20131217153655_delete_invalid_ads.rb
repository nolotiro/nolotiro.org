class DeleteInvalidAds < ActiveRecord::Migration
  # nolotiro v2 - DB legacy
  def up
    # there is at least an Ad without WOEID 
    Ad.where(:woeid_code => 0).each do |ad|
      ad.delete
    end
  end

  def down 
    # We will not create an invalid Ad
  end
end
