# frozen_string_literal: true

class AdRanking
  def initialize(ad_scope, name:, metric:, extra: [])
    @ad_scope = ad_scope
    @name = name
    @metric = metric
    @extra = extra
  end

  def ranked
    @ad_scope.group(@metric, *@extra)
             .order('n_ads DESC')
             .limit(20)
             .pluck(@metric, *@extra, "COUNT(#{@metric}) as n_ads")
  end

  delegate :present?, to: :ranked
end
