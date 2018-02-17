# frozen_string_literal: true

module Geoplanet
  module PathHelper
    def local_compressed_path
      File.join(local_base_path, compressed_name)
    end

    def local_base_path
      Rails.root.join("vendor", "geoplanet")
    end

    def compressed_url
      base_url + compressed_name
    end

    def compressed_name
      "geoplanet_data_7.10.0.zip"
    end

    def base_url
      "https://archive.org/download/geoplanet_data_7.10.0.zip/"
    end
  end
end
