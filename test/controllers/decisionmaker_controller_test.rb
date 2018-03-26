require 'test_helper'

class DecisionmakerControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get decisionmaker_index_url
    assert_response :success
  end

  test "should get new" do
    get decisionmaker_new_url
    assert_response :success
  end

  test "should get create" do
    get decisionmaker_create_url
    assert_response :success
  end

end
