# frozen_string_literal: true

require 'ruby-progressbar'

namespace :conversations do
  desc 'Deletes orphan receipts'
  task remove_orphan_receipts: :environment do
    target = Receipt.joins('LEFT OUTER JOIN users ON users.id = receiver_id')
                    .where(users: { id: nil })

    STDOUT.print "About to delete #{target.size} receipts. Continue? (y/n)"
    abort unless STDIN.gets.chomp == 'y'

    target.destroy_all
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
    todo = Conversation.where(originator_id: nil, recipient_id: nil)

    progress_bar = ProgressBar.create(format: '%c/%C %B %a', total: todo.count)

    todo.find_each do |conversation|
      originator_id = conversation.originator.try(:id)
      recipient_id = conversation.recipient.try(:id)

      conversation.update_column(:originator_id, originator_id)
      conversation.update_column(:recipient_id, recipient_id)

      progress_bar.increment
    end
  end
end
