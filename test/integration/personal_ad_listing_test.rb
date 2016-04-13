require 'test_helper'
require 'integration/concerns/authentication'
require 'integration/concerns/pagination'

class PersonalAdListing < ActionDispatch::IntegrationTest
  include Authentication
  include Pagination

  before do
    @user = create(:user)

    create(:ad, user: @user, title: 'ava_user_1', status: 1)
    create(:ad, user: @user, title: 'ava_user_2', status: 1)
    create(:ad, user: @user, title: 'res_user', status: 2)
    create(:ad, user: @user, title: 'del_user', status: 3)
    create(:ad, title: "something else to ensure it's filtered out")

    with_pagination(1) do
      login(@user.email, @user.password)
      within('.user_login_box') { click_link @user.username }
      click_link 'anuncios'
    end
  end

  it 'lists first page of user available ads in user profile' do
    page.assert_selector '.ad_excerpt_home', count: 1, text: 'ava_user_1'
  end

  it 'lists other pages of user ads in user profile' do
    with_pagination(1) { click_link 'siguiente' }

    page.assert_selector '.ad_excerpt_home', count: 1, text: 'ava_user_2'
  end

  it 'lists user reserved ads in users profile' do
    click_link 'reservado'

    page.assert_selector '.ad_excerpt_home', count: 1, text: 'res_user'
  end

  it 'lists user delivered ads in users profile' do
    click_link 'entregado'

    page.assert_selector '.ad_excerpt_home', count: 1, text: 'del_user'
  end
end
