# frozen_string_literal: true
#
# Wrapper around MaxMind DB search results
#
class MaxMindLocation
  def initialize(info)
    @info = info
  end

  def fullname
    [city, region, country].compact.join(', ')
  end

  def city
    @city ||= localize(@info.city)
  end

  def region
    @region ||= localize(subdivisions[0]) if subdivisions[0]
  end

  def country
    @country ||= localize(@info.country)
  end

  private

  def subdivisions
    @subdivisions ||= @info.subdivisions
  end

  def localize(entity)
    entity.public_send(:name, I18n.locale) || entity.public_send(:name, 'en')
  end
end
