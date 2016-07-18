# frozen_string_literal: true
#
# Wraper around a GeoPlanet::Place search resultset
#
class YahooResultSet
  include Enumerable

  def initialize(result_set)
    @result_set = result_set
  end

  def as_options
    map { |result| [count_label_for(result), result.woeid] }
  end

  private

  def each
    @result_set.each { |result| yield(result) }
  end

  def count_label_for(result)
    fullname = YahooLocation.new(result).fullname
    count = I18n.t('nlt.ads.count', count: ad_counts[result.woeid])

    "#{fullname} (#{count})"
  end

  def ad_counts
    @ad_counts ||= null_ad_counts.merge(non_null_ad_counts)
  end

  def null_ad_counts
    map { |result| [result.woeid, 0] }.to_h
  end

  def non_null_ad_counts
    Ad.where(woeid_code: map(&:woeid)).group(:woeid_code).size
  end
end
