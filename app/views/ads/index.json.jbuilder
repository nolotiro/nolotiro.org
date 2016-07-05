# frozen_string_literal: true
json.array!(@ads) do |ad|
  json.extract! ad, :title, :body, :user_owner, :type, :woeid_code, :ip
  json.url ad_url(ad, format: :json)
end
