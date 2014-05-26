namespace :nolotiro do 
  namespace :migrate do
    namespace :ads do

      desc "[nolotiro] Reprocess the Ad readed_count"
      task :readed_count => :environment do
        connection = ActiveRecord::Base.connection
        query = ActiveRecord::Base.connection.execute("SELECT * FROM readedAdCount")
        query.each do |row|
          # find_by_id doesn't raise ActiveRecord::RecordNotFound
          ad = Ad.find_by_id(row[0])
          unless ad.nil? 
            ad.readed_count = row[1]
            ad.save
          end
        end
        query = ActiveRecord::Base.connection.execute("DROP DATABASE readedAdCount")
      end

    end
  end
end
