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
      end

      desc "[nolotiro] [migrate] [messages] Migrate all the legacy messages and messages_thread to mailboxer"
      task :start => :environment do

        Mailboxer.setup do |config|
          config.uses_emails = false
        end

        #start_a_thread "911694"

        #threads = ["1008701", "1008702", "1008748", "1008801", "1008810", "1008811", "1008812", "1010864", "1015280", "1015281", "1021217"]
        #threads.each {|t| start_a_thread t } 

        start_all_threads
      end

      def get_conversation(message)
        from = message.user_from
        to = message.user_to
        subject = message.thread.subject
        # 1. Busca todos los Receipts por receiver_id basandose en el user_from y user_to del MessageLegacy
        # Agrupa todos sus Receipts por los notification_id que los dos tienen
        # (si dos usuarios tienen el mismo notification_id tuvieron una conversación)
        notification_ids = Receipt.where("receiver_id=? OR receiver_id=?", from, to).count(group: :notification_id).select{|k,v| v > 1}.keys 
        # 2. De ese resultado filtramos los que coincidan con el Subject, devolvemos la Conversation
        notification_ids.each do |n|
          notification = Notification.find_by_id n 
          if notification.subject == subject
            return notification.conversation 
          else
            return nil
          end
        end
      end

      def reply_to_conversation(conversation, from_u, message)
        # It isn't the first, so the Conversation is already there
        if body != ""
          r = from_u.reply_to_conversation(conversation, message.body)
          r.created_at = message.created_at 
          r.updated_at = message.created_at 
          r.message.created_at = message.created_at 
          r.message.updated_at = message.created_at 
          r.message.save
          r.save
          message.update_attribute(:is_migrated, true)
        end
      end

      def start_or_reply_conversation(message_thread, message)

        # nolotirov2 legacy 
        # FIX: hay algunos mensajes que no tienen un user_from (bug legacy)
        #
        # buscamos al usuario y si no lo tiene o es nil lo ponemos como User [borrado]
        from_u = User.find_by_id message.user_from
        to_u = User.find_by_id message.user_to
        if from_u and not to_u
          # invalid user to
          to_u = User.find_by_username "[borrado]"
        else
          # invalid user from
          from_u = User.find_by_username "[borrado]"
        end

        if message ==  message_thread.messages.first
          #start_conversation
          from_u.send_message(to_u, message.body, message.subject, true, nil, message.created_at)
          message.update_attribute(:is_migrated, true)
        else
          conversation = get_conversation(message)
          #conversation = Conversation.find_by_subject message_thread.subject
          unless conversation == [] or conversation.nil?
            reply_to_conversation(conversation, from_u, message)
          else
            puts "******************* INVALID CONVERSATION - maybe it isnt well ordered? - messages #{message.id} *********************"
          end
        end
      end

      def start_all_threads
        ActiveRecord::Base.connection_pool.with_connection do  
          Legacy::Message.where(is_migrated: false).order(:created_at).find_each do |m| 
            # FIXME: MariaDB [nolotirov3]> SELECT COUNT(*) FROM messages_legacy where thread_id = 0 \G
            # *************************** 1. row ***************************
            # COUNT(*): 70598
            #
            unless m.user_from.nil? or m.user_to.nil? or m.thread.nil?
              start_or_reply_conversation(m.thread,m)
            end
          end
        end
      end

      def start_a_thread thread_id
        mt = Legacy::MessageThread.find(thread_id)
        mt.messages.each do |m| 
          start_or_reply_conversation(mt,m)
        end
      end

    end
  end
end
