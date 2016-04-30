namespace :nolotiro do
  desc '[nolotiro] Downloads a maxmind binary Geolite2 db'
  task :download_maxmind_db do
    require 'maxmind_downloader'

    MaxmindDownloader.new.run!
  end
end
