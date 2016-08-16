# frozen_string_literal: true

namespace :conversations do
  desc 'Deletes orphan conversations'
  task remove_orphan: :environment do
    Conversation.joins(:receipts)
                .group(:id)
                .select(:id, 'count(*) as n_receipts')
                .having('n_receipts <= 1')
                .destroy_all
  end
end
