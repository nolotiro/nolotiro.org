# frozen_string_literal: true

json.locations @section_locations do |woeid_id, woeid_name, n_ads|
  json.woeid_id woeid_id
  json.woeid_name woeid_name
  json.ads_count n_ads
end
