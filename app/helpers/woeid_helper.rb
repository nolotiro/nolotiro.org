# frozen_string_literal: true
module WoeidHelper
  def self.convert_woeid_name(woeid)
    locale = I18n.locale
    key = 'woeid_' + locale.to_s + '_' + woeid.to_s
    value = Rails.cache.fetch(key)
    return value if value

    query = <<-SQL.squish
      select * from geo.places where woeid = #{woeid} AND lang = '#{locale}'
    SQL

    place_raw = Yahoo::Fetcher.new(query).fetch
    return if place_raw.nil?

    place = Yahoo::Location.new(place_raw)
    return unless place.town?

    value = { full: place.fullname, short: place.name }
    Rails.cache.write(key, value)
    value
  end

  def self.search_by_name(name)
    return unless name

    query = <<-SQL.squish
      select * from geo.places
      where text = '#{name}' AND placetype = '7' AND lang = '#{I18n.locale}'
    SQL

    raw_locations = Yahoo::Fetcher.new(query).fetch
    return if raw_locations.nil?

    Yahoo::ResultSet.new(Array.wrap(raw_locations))
  end
end
