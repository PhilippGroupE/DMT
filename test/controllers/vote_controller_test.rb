require 'test_helper'

class VoteControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get vote_new_url
    assert_response :success
  end

end
