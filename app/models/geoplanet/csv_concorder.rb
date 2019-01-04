
# frozen_string_literal: true

require "open-uri"
require "csv"
require "geoname_worker"

module Geoplanet
  #
  # Imports woe_id to geoname_id mappings to DB
  #
  class CsvConcorder
    def initialize(remote_url, woe_id_col:, geonames_id_col:)
      @remote_url = remote_url
      @woe_id_col = woe_id_col
      @geonames_id_col = geonames_id_col

      Dir.mkdir(local_base_path) unless File.exist?(local_base_path)

      Rails.logger = Logger.new(STDOUT)
    end

    def concord!
      download!

      process!
    end

    private

    def download!
      Rails.logger.info "Downloading woe_id to geoname_id CSV mapping..."

      return if File.exist?(local_csv_path)

      IO.copy_stream(open(@remote_url), local_csv_path)
    end

    def process!
      Rails.logger.info "Importing woe_id to geoname_id CSV mapping..."

      CSV.foreach(local_csv_path) do |row|
        woe_id = row[@woe_id_col]
        geonames_id = row[@geonames_id_col]

        next unless [woe_id, geonames_id].all?(&:present?)

        GeonameWorker.perform_async(woe_id, geonames_id)
      end
    end

    def local_csv_path
      File.join(local_base_path, csv_mapping_name)
    end

    def local_base_path
      Rails.root.join("vendor", "geoplanet")
    end

    def csv_mapping_name
      File.basename(URI.parse(@remote_url).path)
    end
  end
end
