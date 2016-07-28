# frozen_string_literal: true

namespace :nolotiro do
  desc '[nolotiro] Merge users with different case variations of same email'
  task merge_duplicate_emails: :environment do
    require 'duplicate_email_migrator'

    DuplicateEmailMigrator.migrate!
  end
end
