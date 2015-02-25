module ApplicationHelper

  def get_location_options(woeid)
    # receives a woeid, returns a list of names like it
    WoeidHelper.search_by_name(WoeidHelper.convert_woeid_name(woeid).split(',')[0])
  end

  def cache_key_for(key, current_user)
    key += current_user ? "user_" + current_user.admin?.to_s : "user_nil"
    Digest::MD5.hexdigest(key)
  end

end
