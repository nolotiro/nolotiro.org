# frozen_string_literal: true

require 'test_helper'
require 'integration/concerns/authenticated_test'
require 'support/web_mocking'
require 'minitest/mock'

class ReportingAdsTest < AuthenticatedTest
  include WebMocking

  it 'reports ads' do
    mocking_yahoo_woeid_info(create(:ad).woeid_code) do
      send_report

      assert_text 'Denuncia recibida'
      assert_no_selector 'a', text: 'Denunciar'
    end
  end

  it 'bans authors after a maximum number of reports is received' do
    Report.stub(:max_allowed_score, 0) do
      mocking_yahoo_woeid_info(create(:ad).woeid_code) do
        send_report

        assert_text 'Contenido retirado'
        assert_no_selector 'a', text: 'Denunciar'
      end
    end
  end

  private

  def send_report
    visit root_path
    click_link 'Denunciar'
    choose 'Estafa'
    click_button 'Enviar denuncia'
  end
end
