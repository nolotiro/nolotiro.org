namespace :nolotiro do 
  namespace :migrate do 
    namespace :messages do

      desc "[nolotiro] [migrate] [messages] Delete new migrated messages. Only to use in Development"
      task :delete => :environment do 
        if Rails.env == "development"
          ActiveRecord::Base.establish_connection
          ActiveRecord::Base.connection.execute('UPDATE messages_legacy SET is_migrated = 0;')
          ActiveRecord::Base.connection.execute('UPDATE threads SET conversation_id = 0;')
          ActiveRecord::Base.connection.execute('SET FOREIGN_KEY_CHECKS = 0;')
          ActiveRecord::Base.connection.execute('TRUNCATE table conversations;')  
          ActiveRecord::Base.connection.execute('TRUNCATE table notifications;')
          ActiveRecord::Base.connection.execute('TRUNCATE table receipts;')
          ActiveRecord::Base.connection.execute('SET FOREIGN_KEY_CHECKS = 1;')
        else 
          puts "No development environment, no execution..."
        end
      end

      desc "[nolotiro] [migrate] [messages] Show stats for the migration of all the legacy messages and messages_thread to mailboxer"
      task :count => :environment do 
        total = Legacy::Message.all.count  
        migrated = Legacy::Message.where(is_migrated: true).count  
        no_migrated = Legacy::Message.where(is_migrated: false).count  
        puts migrated * 100.00 / total
        puts no_migrated * 100.00 / total
        puts total
      end

      namespace :start do 
        desc "[nolotiro] [migrate] [messages] Migrate all the legacy messages and messages_thread to mailboxer"
        task :all => :environment do
          Legacy::Message.where(is_migrated: false).order(:created_at).find_each do |m| 
            Resque.enqueue(LegacyMessagesMigratorWorker, m.id) unless m.is_migrated
          end
        end

        desc "[nolotiro] [migrate] [messages] Migrate all the legacy messages and messages_thread to mailboxer - ONLY FOR THE PASTH 2 MONTHS. This is a hack so users can use the messaging right away."
        task :last_months => :environment do
          Legacy::Message.where(is_migrated: false).where(['created_at > ?', 2.month.ago]).order('created_at DESC').find_each do |m|
            Resque.enqueue(LegacyMessagesMigratorWorker, m.id)
          end
        end
      end

    end
  end
end
