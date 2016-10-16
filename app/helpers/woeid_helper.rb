# frozen_string_literal: true

module WoeidHelper
  def self.convert_woeid_name(woeid)
    locale = I18n.locale
    key = 'woeid_' + locale.to_s + '_' + woeid.to_s
    value = Rails.cache.fetch(key)
    return value if value

    town = Town.find(woeid)

    value = { full: town.fullname, short: town.name }
    Rails.cache.write(key, value)
    value
  end

  def self.search_by_name(name)
    return [] unless name.present?

    Yahoo::ResultSet.new(Town.includes(:state, :country).matching(name))
  end
end
