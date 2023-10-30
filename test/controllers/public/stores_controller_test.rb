require "test_helper"

class Public::StoresControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get public_stores_show_url
    assert_response :success
  end
end
