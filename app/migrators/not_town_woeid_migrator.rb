require 'ruby-progressbar'
require 'concerns/yahoo_location'
require 'concerns/woeid_inferer'

#
# Migrates woeids in users table to be all of "town" type.
#
class NotTownWoeidMigrator
  def initialize
    GeoPlanet.appid = Rails.application.secrets['geoplanet_app_id']
  end

  def migrate!
    bar = ProgressBar.create(title: 'Migrating invalid woeids...',
                             total: users.count,
                             format: '%t %a %B %c/%C')

    users.each do |user|
      user.update!(woeid: WoeidInferer.new(user).run)

      bar.increment
    end
  end

  private

  def users
    @users ||= User.where.not(woeid: invalid_locations.map(&:woeid))
  end

  def locations
    @locations ||= YahooLocation.all
  end

  def invalid_locations
    bar = ProgressBar.create(title: 'Detecting invalid woeids...',
                             total: locations.size,
                             format: '%t %a %B %c/%C')

    locations.select do |location|
      status = location.town?

      bar.increment

      status
    end
  end
end
