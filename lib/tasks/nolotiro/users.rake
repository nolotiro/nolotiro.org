# frozen_string_literal: true

namespace :nolotiro do
  desc '[nolotiro] Merge users with different case variations of same email'
  task merge_duplicate_emails: :environment do
    require 'duplicate_email_migrator'

    DuplicateEmailMigrator.migrate!
  end

  desc '[nolotiro] Standarize all emails in DB to lowercase'
  task lowercase_emails: :environment do
    ActiveRecord::Base.connection.execute <<-SQL.squish
      UPDATE users SET email = LOWER(email)
    SQL
  end

  desc '[nolotiro] Remove duplicated usernames from users table'
  task fix_duplicate_usernames: :environment do
    require 'duplicate_username_migrator'

    DuplicateUsernameMigrator.migrate!
  end
end
