# frozen_string_literal: true

#
# Represents a country
#
class Country < ActiveRecord::Base
  validates :iso, presence: true, uniqueness: true
end
