require "test_helper"

class Public::MenusControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get public_menus_index_url
    assert_response :success
  end
end
