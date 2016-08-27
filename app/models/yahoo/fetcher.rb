# frozen_string_literal: true

module Yahoo
  #
  # Single point of interaction with Yahoo's YQL
  #
  class Fetcher
    def initialize(query)
      @query = query
    end

    def fetch
      results = JSON.parse(response.body)['query']['results']
      return unless results

      results['place']
    end

    private

    def response
      @response ||= RestClient.get base_uri, params: { q: @query, format: 'json' }
    end

    def base_uri
      'http://query.yahooapis.com/v1/public/yql'
    end
  end
end
