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
end
