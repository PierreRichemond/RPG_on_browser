require "test_helper"

class FightfightersControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get fightfighters_show_url
    assert_response :success
  end
end
