# frozen_string_literal: true

namespace :geoplanet do
  desc "Imports Geoplanet compressed db from archive.org"
  task import: :environment do
    require "geoplanet/importer"

    Geoplanet::Importer.new.import!
  end

  namespace :concordances do
    desc "Adds whosonfirst geonames' concordances to geographical tables"
    task wof: :environment do
      require "geoplanet/csv_concorder"

      Geoplanet::CsvConcorder.new(
        "https://media.githubusercontent.com/media/whosonfirst-data/whosonfirst-data/master/meta/wof-concordances-latest.csv",
        woe_id_col: 6,
        geonames_id_col: 1
      ).concord!
    end

    desc "Adds blackmad geonames' concordances to geographical tables"
    task blackmad: :environment do
      require "geoplanet/csv_concorder"

      Geoplanet::CsvConcorder.new(
        "https://raw.githubusercontent.com/blackmad/geoplanet-concordance/master/current/geonames-geoplanet-matches.csv",
        woe_id_col: 0,
        geonames_id_col: 1
      ).concord!
    end
  end
end
