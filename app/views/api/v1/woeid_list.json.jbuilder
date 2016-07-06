# frozen_string_literal: true
json.locations @section_locations do |loc|
  json.woeid_id loc[1]
  json.woeid_name loc[0]
  json.ads_count loc[2]
end
