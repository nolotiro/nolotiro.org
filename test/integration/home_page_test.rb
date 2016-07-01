require 'test_helper'

class HomePageTest < ActionDispatch::IntegrationTest
  it 'shows a link to show ads in the guessed location' do
    get root_path, {}, 'REMOTE_ADDR' => '8.8.8.8'

    assert_select 'a', 'Ver anuncios en Mountain View'
  end
end
