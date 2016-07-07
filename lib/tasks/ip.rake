# frozen_string_literal: true

namespace :ip do
  desc 'Validates all IPs in DB'
  task validate: :environment do
    Ad.find_each do |ad|
      ip = ad.ip
      next if ip.nil? || IPAddress.valid?(ip)

      valid_ip = ip.split(',').map(&:strip).find { |s| IPAddress.valid?(s) }
      ad.update!(ip: valid_ip)
    end
  end
end
