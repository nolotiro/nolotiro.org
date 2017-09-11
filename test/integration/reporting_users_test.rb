# frozen_string_literal: true

require 'test_helper'
require 'integration/concerns/js_authenticated_test'
require 'support/web_mocking'
require 'minitest/mock'

module ReportUsersTests
  include WebMocking

  def test_reports_users
    send_report

    assert_text 'Denuncia recibida. ¡Gracias!'
    assert_no_link link_label
  end

  def test_bans_authors_after_a_maximum_number_of_reports_is_received
    User.stub(:max_allowed_report_score, 0) do
      mocking_yahoo_woeid_info(@current_user.woeid) { send_report }

      assert_text 'Contenido retirado. ¡Gracias!'
      assert_no_link link_label
    end
  end

  private

  def send_report
    accept_confirm { click_link link_label }
  end
end

class ReportingUsersFromProfileTest < JsAuthenticatedTest
  include ReportUsersTests

  def setup
    super

    @user = create(:user)
    visit profile_path(@user)
  end

  private

  def link_label
    'denunciar'
  end
end

class ReportingUsersFromAdPageTest < JsAuthenticatedTest
  include WebMocking
  include ReportUsersTests

  def setup
    super

    @ad = create(:ad)

    mocking_yahoo_woeid_info(@ad.woeid_code) do
      visit adslug_path(@ad, slug: @ad.slug)
    end
  end

  private

  def link_label
    'Denunciar'
  end
end
