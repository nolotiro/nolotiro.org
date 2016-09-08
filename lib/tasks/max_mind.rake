# frozen_string_literal: true

namespace :max_mind do
  desc 'Updates MaxMind Geolite2 City db'
  task update: :environment do
    require 'max_mind/fetcher'

    MaxMind::Fetcher.new.update!
  end

  desc "Extracts MaxMind's GeoLite2 City compressed db"
  task extract: :environment do
    require 'max_mind/fetcher'

    MaxMind::Fetcher.new.extract!
  end
end
