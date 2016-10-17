# frozen_string_literal: true

module WoeidHelper
  def self.search_by_name(name)
    return [] unless name.present?

    Yahoo::ResultSet.new(Town.includes(:state, :country).matching(name))
  end
end
