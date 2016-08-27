# frozen_string_literal: true

module Yahoo
  #
  # Wrapper around a Yahoo YQL woeid
  #
  class Location
    def initialize(place)
      @place = place
    end

    def fullname
      "#{name}, #{admin1}, #{country}"
    end

    def name
      @place['name']
    end

    def woeid
      @place['woeid'].to_i
    end

    def town?
      typecode == '7'
    end

    private

    def admin1
      @place['admin1']['content']
    end

    def country
      @place['country']['content']
    end

    def typecode
      @place['placeTypeName']['code']
    end
  end
end
