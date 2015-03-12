# encoding : utf-8
module AdHelper

  def self.get_users_ranking 
    User.order("ads_count DESC").select('username, ads_count, id').limit(40)
  end

  def self.get_locations_ranking
    Ad.give.group_by(&:woeid_code).map{ |w,a| [WoeidHelper.convert_woeid_name(w), w, a.count] }.sort_by{|k| k[2]}.reverse.take(80) 
  end

end
