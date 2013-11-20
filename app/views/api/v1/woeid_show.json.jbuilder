json.woeid_id  @woeid
json.woeid_name WoeidHelper.convert_woeid_name @woeid
json.ads @ads do |ad|
  json.id ad.id
  json.title ad.title
  json.body ad.body
end
