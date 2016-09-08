# frozen_string_literal: true

require 'open-uri'

module MaxMind
  #
  # Imports geographical Database information from MaxMind
  #
  class Fetcher
    def update!
      download!
      extract!
    end

    def download!
      IO.copy_stream(open(compressed_db_url), local_compressed_db_path)
    end

    def extract!
      Zlib::GzipReader.open(local_compressed_db_path) do |input_stream|
        File.open(local_db_path, 'w') do |output_stream|
          IO.copy_stream(input_stream, output_stream)
        end
      end

      raise 'DB does not match expected checksum' unless valid?
    end

    def valid?
      compressed_db_checksum == local_compressed_db_checksum
    end

    private

    def local_compressed_db_checksum
      return '' unless File.exist?(local_db_path)

      Digest::MD5.file(local_db_path).hexdigest
    end

    def compressed_db_checksum
      open(checksum_url).read
    end

    def compressed_db_url
      base_url + compressed_db_name
    end

    def checksum_url
      base_url + base_name + '.md5'
    end

    def local_db_path
      File.join(local_base_path, db_name)
    end

    def local_compressed_db_path
      File.join(local_base_path, compressed_db_name)
    end

    def compressed_db_name
      db_name + '.gz'
    end

    def db_name
      base_name + '.mmdb'
    end

    def local_base_path
      File.join(Rails.root, 'vendor', 'geolite')
    end

    def base_url
      'https://geolite.maxmind.com/download/geoip/database/'
    end

    def base_name
      'GeoLite2-City'
    end
  end
end
