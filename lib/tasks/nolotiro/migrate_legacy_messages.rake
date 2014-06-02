namespace :nolotiro do 
  namespace :migrate do 
    namespace :messages do

      desc "[nolotiro] [migrate] [messages] Show stats for the migration of all the legacy messages and messages_thread to mailboxer"
      task :count => :environment do 
        total = Legacy::Message.all.count  
        migrated = Legacy::Message.where(is_migrated: true).count  
        no_migrated = Legacy::Message.where(is_migrated: false).count  
        puts migrated * 100.00 / total
        puts no_migrated * 100.00 / total
        puts total
      end

      desc "[nolotiro] [migrate] [messages] Migrate all the legacy messages and messages_thread to mailboxer"
      task :start_all => :environment do
        Legacy::Message.where(is_migrated: false).order(:created_at).find_each do |m| 
          Resque.enqueue(LegacyMessagesMigratorWorker, m.id)
        end
      end

      desc "[nolotiro] [migrate] [messages] Migrate all the legacy messages and messages_thread to mailboxer - ONLY FOR THE PASTH MONTH. This is a hack so users can use the messaging right away."
      task :start_last_month => :environment do
        Legacy::Message.where(is_migrated: false).where(['created_at > ?', 1.month.ago]).order('created_at DESC').find_each do |m|
          Resque.enqueue(LegacyMessagesMigratorWorker, m.id)
        end
      end

    end
  end
end
