# frozen_string_literal: true

namespace :users do
  desc 'Merge users with different case variations of same email'
  task merge_duplicate_users: :environment do
    require 'duplicate_user_merger'

    DuplicateUserMerger.merge!
  end
end
