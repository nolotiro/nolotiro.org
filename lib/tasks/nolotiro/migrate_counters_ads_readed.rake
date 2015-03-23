namespace :nolotiro do 
  namespace :migrate do
    namespace :counters do
      desc "[nolotiro] Reprocess the Ad readed_count"
      task :ads_readed => :environment do
        connection = ActiveRecord::Base.connection
        query = ActiveRecord::Base.connection.execute("SELECT * FROM readedAdCount")
        query.each do |row|
          # find_by_id doesn't raise ActiveRecord::RecordNotFound
          ad = Ad.find_by_id(row[0])
          unless ad.nil? 
            ad.update_attribute(:readed_count, row[1])
            ad.save
          end
        end
        query = ActiveRecord::Base.connection.execute("DROP DATABASE readedAdCount")
      end
    end
  end
end
