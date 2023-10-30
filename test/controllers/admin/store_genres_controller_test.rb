require "test_helper"

class Admin::StoreGenresControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_store_genres_index_url
    assert_response :success
  end

  test "should get edit" do
    get admin_store_genres_edit_url
    assert_response :success
  end
end
