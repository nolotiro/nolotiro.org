# frozen_string_literal: true

namespace :max_mind do
  desc 'Downloads a MaxMind binary Geolite2 db'
  task download: :environment do
    require 'max_mind/downloader'

    MaxMind::Downloader.new.run!
  end
end
