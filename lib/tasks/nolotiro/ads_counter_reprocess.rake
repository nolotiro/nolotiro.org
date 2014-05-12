namespace :nolotiro do 

  desc "[nolotiro] Reprocess the Ad readed_count"
  task :ads_counter_reprocess => :environment do
    User.reset_column_information

    User.find_each do |u|
      u.update_attribute :ads_count, u.ads.count
    end
  end

end
