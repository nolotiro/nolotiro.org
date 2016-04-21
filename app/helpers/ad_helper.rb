# encoding : utf-8
module AdHelper

  def self.get_locations_ranking(limit=20)
    Ad.unscoped.give.group(:woeid_code).order('count_id desc').limit(limit).count('id').map do |w, c|
      [WoeidHelper.convert_woeid_name(w)[:full], w, c]
    end
  end

end
