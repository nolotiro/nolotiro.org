# frozen_string_literal: true
if Rails.env.production? or Rails.env.staging?
  Airbrake.configure do |config|
    config.api_key = Rails.application.secrets.airbrake['apikey']
    config.host    = Rails.application.secrets.airbrake['host']
    config.port    = Rails.application.secrets.airbrake['port']
    config.secure  = config.port == 443
  end
end

#class AirbrakeDeliveryWorker
#  include Airbrake
#  include Sidekiq::Worker
#  sidekiq_options queue: :airbrake, retry: false
#
#  def perform(notice)
#    Airbrake.sender.send_to_airbrake notice
#  end
#end
#
#Airbrake.configure do |config|
#  config.api_key = Rails.application.secrets.airbrake["apikey"]
#  config.host    = Rails.application.secrets.airbrake["host"]
#  config.port    = Rails.application.secrets.airbrake["port"]
#  config.async do |notice| 
#    AirbrakeDeliveryWorker.perform_async(notice.to_xml)
#  end
#end
