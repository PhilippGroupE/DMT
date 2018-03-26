require 'test_helper'

class DecisionroomControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get decisionroom_index_url
    assert_response :success
  end

  test "should get show" do
    get decisionroom_show_url
    assert_response :success
  end

  test "should get new" do
    get decisionroom_new_url
    assert_response :success
  end

  test "should get create" do
    get decisionroom_create_url
    assert_response :success
  end

  test "should get update" do
    get decisionroom_update_url
    assert_response :success
  end

  test "should get delete" do
    get decisionroom_delete_url
    assert_response :success
  end

end
