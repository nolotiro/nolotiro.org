# encoding : utf-8
module AdHelper

  def self.get_users_ranking 
    User.order("ads_count DESC").select('username, ads_count, id').limit(40)
  end

  def self.get_locations_ranking
    key = 'section_locations'
    if Rails.cache.fetch(key)
      section_locations = Rails.cache.fetch(key)
    else
      section_locations = Ad.available.group_by(&:woeid_code).map { |w,a| [w, a.count] }
      Rails.cache.write(key, section_locations)
    end
    section_locations
  end


end
