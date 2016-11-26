# frozen_string_literal: true

class AdRanking
  def initialize(ad_scope, name:, metric:, select_extras: [], map_extras: [])
    @ad_scope = ad_scope
    @name = name
    @metric = metric
    @select_extras = select_extras
    @map_extras = map_extras
  end

  def ranked
    Rails.cache.fetch("#{@name}-#{cache_digest}") do
      @ad_scope.select(@metric, *@select_extras, "COUNT(#{@metric}) as n_ads")
               .group(*@select_extras, @metric)
               .order('n_ads DESC')
               .limit(20)
               .map do |entry|
        [
          entry.send(@metric),
          *(@select_extras + @map_extras).map { |extra| entry.send(extra) },
          entry.n_ads
        ]
      end
    end
  end

  delegate :present?, to: :ranked

  private

  def cache_digest
    last_ad_publication = Ad.give.maximum(:published_at)
    return '0' * 20 unless last_ad_publication

    last_ad_publication.strftime('%d%m%y%H%M%s')
  end
end
