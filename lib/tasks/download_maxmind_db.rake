# frozen_string_literal: true
desc 'Downloads a maxmind binary Geolite2 db'
task download_maxmind_db: :environment do
  require 'maxmind_downloader'

  MaxmindDownloader.new.run!
end
