module ApplicationHelper

  def get_location_options(woeid)
    # receives a woeid, returns a list of names like it
    WoeidHelper.search_by_name(WoeidHelper.convert_woeid_name(woeid).split(',')[0])
  end

end
