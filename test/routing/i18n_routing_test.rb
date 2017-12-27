# frozen_string_literal: true

require 'test_helper'
require 'support/web_mocking'

class I18nRoutingTest < ActionDispatch::IntegrationTest
  include WebMocking

  before do
    @ad = create(:ad)
  end

  I18n.available_locales.each do |l|
    define_method(:"test_i18n_for_#{l}_works") do
      I18n.with_locale(:es) do
        mocking_yahoo_woeid_info(@ad.woeid_code, l) do
          params = {
            controller: 'woeid', action: 'show', type: 'give', locale: l.to_s
          }
          assert_recognizes params, "/#{l}"
          get "/#{l}"
          assert_response :success, "couldn't GET /#{l}"
        end
      end
    end
  end
end
