require "test_helper"

class FightersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get fighters_index_url
    assert_response :success
  end

  test "should get show" do
    get fighters_show_url
    assert_response :success
  end

  test "should get new" do
    get fighters_new_url
    assert_response :success
  end

  test "should get create" do
    get fighters_create_url
    assert_response :success
  end

  test "should get destroy" do
    get fighters_destroy_url
    assert_response :success
  end

  test "should get edit" do
    get fighters_edit_url
    assert_response :success
  end

  test "should get update" do
    get fighters_update_url
    assert_response :success
  end
end
