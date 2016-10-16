# frozen_string_literal: true

module Yahoo
  #
  # Wrapper around a set of Yahoo YQL woeids
  #
  class ResultSet
    include Enumerable

    def initialize(locations)
      @locations = locations
    end

    def as_options
      map do |location|
        woeid = location.id
        count = I18n.t('nlt.n_ads', count: ad_counts[woeid])
        label = "#{location.fullname} (#{count})"

        [label, woeid]
      end
    end

    private

    def each
      @locations.each { |result| yield(result) }
    end

    def woeids
      @woeids ||= map(&:id)
    end

    def ad_counts
      @ad_counts ||= null_ad_counts.merge(non_null_ad_counts)
    end

    def null_ad_counts
      woeids.zip([0] * woeids.size).to_h
    end

    def non_null_ad_counts
      Ad.give.where(woeid_code: woeids).group(:woeid_code).size
    end
  end
end
