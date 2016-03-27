# encoding : utf-8
module AdHelper

  def self.get_locations_ranking(limit=20, locale)
    Ad.give.group_by(&:woeid_code).map{ |w,a| [WoeidHelper.convert_woeid_name(w,locale)[:full], w, a.count] }.sort_by{|k| k[2]}.reverse.take(limit) 
  end

end
