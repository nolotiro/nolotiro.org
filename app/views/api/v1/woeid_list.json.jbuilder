# frozen_string_literal: true

json.locations @section_locations do |loc|
  json.woeid_id loc.woeid_code
  json.woeid_name loc.woeid_name_short
  json.ads_count loc.n_ads
end
