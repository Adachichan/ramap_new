require "test_helper"

class Public::MystoresControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get public_mystores_index_url
    assert_response :success
  end

  test "should get new" do
    get public_mystores_new_url
    assert_response :success
  end

  test "should get show" do
    get public_mystores_show_url
    assert_response :success
  end

  test "should get edit" do
    get public_mystores_edit_url
    assert_response :success
  end

  test "should get closing_confirm" do
    get public_mystores_closing_confirm_url
    assert_response :success
  end
end
