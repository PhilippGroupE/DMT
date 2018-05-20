require 'test_helper'

class FirstDecisionAnalysisControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get first_decision_analysis_index_url
    assert_response :success
  end

end
