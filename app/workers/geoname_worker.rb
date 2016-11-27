# frozen_string_literal: true

class GeonameWorker
  include Sidekiq::Worker

  def perform(woe_id, geoname_id)
    add_mapping_for(Town, woe_id, geoname_id) ||
      add_mapping_for(State, woe_id, geoname_id) ||
      add_mapping_for(Country, woe_id, geoname_id)
  end

  private

  def add_mapping_for(klass, woe_id, geoname_id)
    place = klass.find_by(id: woe_id)
    return unless place

    place.update!(geoname_id: geoname_id)
  end
end
