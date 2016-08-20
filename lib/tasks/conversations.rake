# frozen_string_literal: true

namespace :conversations do
  desc 'Deletes orphan receipts'
  task remove_orphan_receipts: :environment do
    target = Receipt.joins('LEFT OUTER JOIN users ON users.id = receiver_id')
                    .where(users: { id: nil })

    STDOUT.print "About to delete #{target.size} receipts. Continue? (y/n)"
    abort unless STDIN.gets.chomp == 'y'

    target.destroy_all
  end

  desc 'Nullify orphan senders'
  task nullify_orphan_senders: :environment do
    target = Message.joins('LEFT OUTER JOIN users on users.id = sender_id')
                    .where(users: { id: nil })
                    .where.not(sender_id: nil)

    STDOUT.print "About to nullify #{target.size} sender_id's. Continue? (y/n)"
    abort unless STDIN.gets.chomp == 'y'

    target.update_all(sender_id: nil)
  end

  desc 'Deletes garbage conversations (no receipts at all)'
  task remove_garbage: :environment do
    joined = Conversation.joins <<-SQL.squish
      LEFT OUTER JOIN messages ON conversations.id = conversation_id
      LEFT OUTER JOIN receipts ON messages.id = notification_id
    SQL

    target = joined.where(receipts: { notification_id: nil }).distinct

    STDOUT.print "About to delete #{target.size} conversations. Continue? (y/n)"
    abort unless STDIN.gets.chomp == 'y'

    target.destroy_all
  end

  desc 'Fills in originators & recipients for conversations'
  task fill_originators_and_recipients: :environment do
    Conversation.where(originator_id: nil, recipient_id: nil).ids.each do |id|
      ConversationWorker.perform_async(id)
    end
  end
end
