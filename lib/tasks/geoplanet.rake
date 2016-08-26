# frozen_string_literal: true

namespace :geoplanet do
  desc 'Imports Geoplanet compressed db from archive.org'
  task import: :environment do
    require 'geoplanet/importer'

    Geoplanet::Importer.new.import!
  end
end
