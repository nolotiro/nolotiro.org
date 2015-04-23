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
          ActiveRecord::Base.connection.execute('TRUNCATE TABLE mailboxer_conversations;')  
          ActiveRecord::Base.connection.execute('TRUNCATE TABLE mailboxer_notifications;')
          ActiveRecord::Base.connection.execute('TRUNCATE TABLE mailboxer_receipts;')
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
        migrated_percent =  migrated * 100.00 / total
        no_migrated_percent = no_migrated * 100.00 / total
        puts "Migradas #{migrated} - #{migrated_percent}%"
        puts "Por migrar #{no_migrated} - #{no_migrated_percent}%"
        puts total
      end

      namespace :start do 
        desc "[nolotiro] [migrate] [messages] Migrate all the legacy messages and messages_thread to mailboxer"
        task :all => :environment do
          messages = Legacy::Message.where(is_migrated: false).order(:created_at)
          messages.find_each do |message| 
            LegacyMessagesMigratorWorker.perform_async(message.thread_id) unless message.thread_id == 0
          end
        end

        desc "[nolotiro] [migrate] [messages] Migrate all the legacy messages and messages_thread to mailboxer - ONLY FOR THE PASTH 2 MONTHS. This is a hack so users can use the messaging right away."
        task :last_months => :environment do
          messages = Legacy::Message.where(is_migrated: false).where(['created_at > ?', 2.month.ago]).order('created_at DESC')
          messages.find_each do |message|
            LegacyMessagesMigratorWorker.perform_async(message.thread_id) unless message.thread_id == 0
            #Legacy::MessageThread.find(message.thread_id).migrate!
          end
        end

        desc "[nolotiro] [migrate] [messages] Migrate samples for error on migration (privacy bug)."
        task :sample => :environment do
          #threads = []
          #threads_ids.each do |th|
          #  thread = Legacy::MessageThread.find th
          #  thread.migrate!
          #end
          #
          #messages_ids = [] 
          #Legacy::Message.find(messages_ids).each do |m|
          #  LegacyMessagesMigratorWorker.perform_async(message.thread_id) unless message.thread_id == 0
          #end
          #
        end
      end

    end
  end
end
