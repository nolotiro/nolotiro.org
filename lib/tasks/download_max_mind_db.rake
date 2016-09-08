# frozen_string_literal: true

desc 'Downloads a MaxMind binary Geolite2 db'
task download_max_mind_db: :environment do
  require 'max_mind_downloader'

  MaxMindDownloader.new.run!
end
