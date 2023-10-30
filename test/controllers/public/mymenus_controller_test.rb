require "test_helper"

class Public::MymenusControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get public_mymenus_index_url
    assert_response :success
  end

  test "should get edit" do
    get public_mymenus_edit_url
    assert_response :success
  end
end
