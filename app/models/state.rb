# frozen_string_literal: true

#
# Represents a first level state in a country.
#
class State < ActiveRecord::Base
  belongs_to :country
  validates :country, presence: true
end
