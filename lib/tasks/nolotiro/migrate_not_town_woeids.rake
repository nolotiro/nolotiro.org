namespace :nolotiro do
  namespace :migrate do
    desc '[nolotiro] Migrates user woeids that are not towns'
    task not_town_woeids: :environment do
      require 'not_town_woeid_migrator'

      NotTownWoeidMigrator.new.migrate!
    end
  end
end
