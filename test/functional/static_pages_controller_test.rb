require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase
  test "should get community_map" do
    get :community_map
    assert_response :success
  end

  test "should get help" do
    get :help
    assert_response :success
  end

end
