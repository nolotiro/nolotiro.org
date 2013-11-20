json.locations @section_locations do |loc|
  json.woeid_id loc[0]
  json.woeid_name WoeidHelper.convert_woeid_name loc[0]
  json.ads_count loc[1]
end
