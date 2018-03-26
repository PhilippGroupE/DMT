require 'test_helper'

class TableControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get table_new_url
    assert_response :success
  end

  test "should get show" do
    get table_show_url
    assert_response :success
  end

  test "should get edit" do
    get table_edit_url
    assert_response :success
  end

  test "should get delete" do
    get table_delete_url
    assert_response :success
  end

end
