# encoding : utf-8
# frozen_string_literal: true
module AdHelper
  def self.get_locations_ranking(limit = 20)
    Ad.give.group(:woeid_code).order('count_id desc').limit(limit).count('id').map do |w, c|
      [WoeidHelper.convert_woeid_name(w)[:short], w, c]
    end
  end
end
