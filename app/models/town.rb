# frozen_string_literal: true

#
# A town on Earth
#
class Town < ActiveRecord::Base
  belongs_to :state
  belongs_to :country

  scope :matching_rank, ->(text) do
    sum_sql = 'SUM(CASE ads.type WHEN 1 THEN 1 ELSE 0 END)'
    concat_sql = "CONCAT(towns.name, ', ', states.name, ', ', countries.name)"

    matching(text)
      .select(:id, "#{sum_sql} as n_ads", "#{concat_sql} as label")
      .joins('LEFT OUTER JOIN ads on ads.woeid_code = towns.id')
      .group(:id, 'towns.name', 'states.name', 'countries.name')
      .order('n_ads DESC')
  end

  scope :matching, ->(text) do
    keywords = text.split(',').map(&:strip)
    return none if keywords.empty?

    case keywords.size
    when 1 then by_name(*keywords)
    when 2 then by_name_and_state(*keywords)
    else by_name_state_and_country(*keywords)
    end
  end

  scope :by_name, ->(name) do
    joins(:state, :country)
      .where('UNACCENT(towns.name) ILIKE UNACCENT(?)', "%#{name}%")
  end

  scope :by_name_and_state, ->(name, state) do
    by_name(name)
      .where('UNACCENT(states.name) ILIKE UNACCENT(?)', "%#{state}%")
  end

  scope :by_name_state_and_country, ->(name, state, country) do
    by_name_and_state(name, state)
      .where('UNACCENT(countries.name) ILIKE UNACCENT(?)', "%#{country}%")
  end

  def fullname
    [name, state&.name, country.name].compact.join(', ')
  end
end
