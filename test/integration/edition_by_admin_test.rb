require "test_helper"
require "integration/concerns/authentication"

class EditionsByAdmin < ActionDispatch::IntegrationTest
  include Authentication

  before do
    @ad = FactoryGirl.create(:ad, woeid_code: 766273, type: 1)
    login_as FactoryGirl.create(:admin, woeid: 766272)
  end

  it "changes only the edited attribute" do
    visit ads_edit_path(@ad)
    select "busco...", from: "ad_type"
    click_button "Enviar"

    assert_equal 766273, @ad.reload.woeid_code
    assert_equal 2, @ad.reload.type
  end
end
