# frozen_string_literal: true

namespace :conversations do
  desc "Deletes garbage conversations (no receipts at all)"
  task remove_garbage: :environment do
    joined = Conversation.joins <<-SQL.squish
      LEFT OUTER JOIN messages ON conversations.id = conversation_id
      LEFT OUTER JOIN receipts ON messages.id = notification_id
    SQL

    target = joined.where(receipts: { notification_id: nil }).distinct

    STDOUT.print "About to delete #{target.size} conversations. Continue? (y/n)"
    abort unless STDIN.gets.chomp == "y"

    target.destroy_all
  end
end
