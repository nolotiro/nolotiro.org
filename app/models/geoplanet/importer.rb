# frozen_string_literal: true

require "open-uri"
require "zip"
require "geoplanet/path_helper"
require "geoplanet/raw_importer"

module Geoplanet
  #
  # Imports geographical Database information from Yahoo Geoplanet
  #
  class Importer
    include PathHelper

    def initialize
      Dir.mkdir(local_base_path) unless File.exist?(local_base_path)

      Rails.logger = Logger.new(STDOUT)
    end

    def import!
      download!

      RawImporter.new(
        connection,
        "places",
        %w[woe_id iso name language place_type parent_id]
      ).import!

      RawImporter.new(
        connection,
        "admins",
        %w[woe_id iso state county local_admin country continent]
      ).import!

      import_countries!
      import_states!
      import_towns!
    end

    private

    def download!
      Rails.logger.info "Downloading DB from archive.org..."

      return if File.exist?(local_compressed_path)

      IO.copy_stream(open(compressed_url), local_compressed_path)
    end

    def import_countries!
      Rails.logger.info "Importing countries..."

      connection.execute <<-SQL.squish
        INSERT INTO countries(id, name, iso)
        SELECT CAST(p.woe_id AS INTEGER), p.name, p.iso
        FROM yahoo_places p
        WHERE p.place_type in ('Country', 'Nationality')
      SQL
    end

    def import_states!
      Rails.logger.info "Importing states..."

      connection.execute <<-SQL.squish
        INSERT INTO states(id, name, country_id)
        SELECT CAST(p.woe_id AS INTEGER), p.name, CAST(a.country AS INTEGER)
        FROM yahoo_places p INNER JOIN yahoo_admins a ON p.woe_id = a.woe_id
        WHERE p.place_type = 'State'
      SQL
    end

    def import_towns!
      Rails.logger.info "Importing towns..."

      connection.execute <<-SQL.squish
        INSERT INTO towns(id, name, state_id, country_id)
        SELECT
          CAST(p.woe_id AS INTEGER),
          p.name,
          CAST(NULLIF(a.state, '0') AS INTEGER),
          CAST(a.country AS INTEGER)
        FROM yahoo_places p INNER JOIN yahoo_admins a ON p.woe_id = a.woe_id
        WHERE p.place_type = 'Town'
      SQL
    end

    def connection
      @connection ||= ActiveRecord::Base.connection
    end
  end
end
