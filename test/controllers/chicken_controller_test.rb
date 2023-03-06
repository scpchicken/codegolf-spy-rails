require "test_helper"

class ChickenControllerTest < ActionDispatch::IntegrationTest
  test "should get chicken" do
    get chicken_chicken_url
    assert_response :success
  end
end
