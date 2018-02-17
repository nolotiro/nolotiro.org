# frozen_string_literal: true

require "zip"
require "geoplanet/path_helper"

module Geoplanet
  #
  # Imports a resource from Geoplanet into our DB
  #
  class RawImporter
    include PathHelper

    attr_reader :resource, :columns, :connection

    def initialize(connection, resource, columns)
      @connection = connection
      @resource = resource
      @columns = columns
    end

    def import!
      Rails.logger.info "Importing raw #{resource}..."

      extract_file!
      cleanup_orphan_entries!
      create_temporary_table!
      copy_file_to_temporary_table!
    end

    def extract_file!
      Zip::File.open(local_compressed_path) do |zip_file|
        zip_file.find_entry(tsv_name).extract(tsv_path) { true }
      end
    end

    def cleanup_orphan_entries!
      system("sed", "-i", "/^1321121\t/d", tsv_path)
    end

    def create_temporary_table!
      connection.create_table :"yahoo_#{resource}", temporary: true do |t|
        columns.each { |column| t.string column.to_sym }
      end
    end

    def copy_file_to_temporary_table!
      sql = <<-SQL.squish
        COPY yahoo_#{resource}(#{columns.join(', ')}) FROM STDIN WITH CSV HEADER
      SQL

      raw_connection.copy_data(sql) do
        File.open(tsv_path, "r").each do |line|
          raw_connection.put_copy_data(line.tr("\t", ","))
        end
      end

      loop do
        res = raw_connection.get_result
        return unless res

        error_message = res.error_message
        next unless error_message

        Rails.logger.warn error_message
      end
    end

    delegate :raw_connection, to: :connection

    def tsv_name
      "geoplanet_#{resource}_7.10.0.tsv"
    end

    def tsv_path
      File.join(local_base_path, tsv_name)
    end
  end
end
