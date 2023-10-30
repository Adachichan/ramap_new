require "test_helper"

class Admin::StoresControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get admin_stores_show_url
    assert_response :success
  end

  test "should get edit" do
    get admin_stores_edit_url
    assert_response :success
  end

  test "should get change_confirm" do
    get admin_stores_change_confirm_url
    assert_response :success
  end
end
