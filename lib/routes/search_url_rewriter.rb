# frozen_string_literal: true

class SearchUrlRewriter
  def call(params, request)
    raw_query = URI.escape(request.query_string)
    query = Rack::Utils.parse_query(raw_query).symbolize_keys

    new_path = "#{params[:locale]}/woeid/#{rewritten_woeid(query)}"
    new_path = "#{new_path}/#{rewritten_type(query)}"
    new_path = "#{new_path}/status/#{query[:status]}" if query[:status].present?
    new_path = "#{new_path}/page/#{query[:page]}" if query[:page].present?

    "#{new_path}?q=#{query[:q]}"
  end

  private

  def rewritten_woeid(query)
    query[:woeid] || query[:woeid_code]
  end

  def rewritten_type(query)
    if query[:ad_type].present?
      query[:ad_type] == '2' ? 'want' : 'give'
    elsif query[:type].present?
      query[:type]
    else
      'give'
    end
  end
end
