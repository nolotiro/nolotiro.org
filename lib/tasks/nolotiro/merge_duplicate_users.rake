namespace :nolotiro do
  namespace :merge do
    desc '[nolotiro] Merge users with different case variations of same email'
    task duplicate_users: :environment do
      require 'duplicate_user_migrator'

      DuplicateUserMigrator.migrate!
    end
  end
end
