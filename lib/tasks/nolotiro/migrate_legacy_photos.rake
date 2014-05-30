namespace :nolotiro do 
  namespace :migrate do 
    namespace :images do

      desc "[nolotiro] Migrate all the legacy photos"
      task :start => :environment do
        # nolotiro v2 legacy 
        # missing photos :/
        files = [
          "35fa6b901391b306fec4ce241df300f4.jpg",
          "795668875474b157f26169d567f70188.JPG",
          "094ac5e4f303a85c667dc83628857e8c.jpg",
          "1c93f6ee8a126455913226623cceb612.jpg",
          "faede1067a93230f4193c140cee11daf.jpg",
          "7979d7671e6cd39d9e8f4b73a7a0732f.JPG",
          "e4536de7d08ccb7b3c7fcb0f5d2bbfea.JPG",
          "24f4a054684cc9b33385a20d00a206f9.jpg",
        ]
        # Touch missing photos
        files.each do |f|
          File.open(Rails.root.to_s + "/public/legacy/uploads/ads/original/" + f, "w") {} 
        end
        ads = Ad.where.not(photo: nil).where(image_file_name: nil) 
        ads.find_each do |ad|
          # For all Ads if they have photo we are going to the original photo file and 
          # save it as image; the photo attribute after the conversion is nil 
          filename = Rails.root.to_s + '/public/legacy/uploads/ads/original/' + ad.photo
          #  if File.file?(filename)
          file = File.new(filename, "r")
          ad.image = file
          ad.photo = nil
          ad.save
          file.close
          #  end
        end

      end
    end
  end
end
