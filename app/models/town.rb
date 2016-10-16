# frozen_string_literal: true

#
# A town on Earth
#
class Town < ActiveRecord::Base
  belongs_to :state
  belongs_to :country

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
    joins(:state, :country).where('towns.name ILIKE ?', "%#{name}%")
  end

  scope :by_name_and_state, ->(name, state) do
    by_name(name).where('states.name ILIKE ?', "%#{state}%")
  end

  scope :by_name_state_and_country, ->(name, state, country) do
    by_name_and_state(name, state)
      .where('countries.name ILIKE ?', "%#{country}%")
  end

  def fullname
    [name, state&.name, country.name].compact.join(', ')
  end
end
