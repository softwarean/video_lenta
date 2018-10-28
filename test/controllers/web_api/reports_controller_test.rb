require 'test_helper'

class WebApi::ReportsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index, format: :json
    assert_response :success
  end

end
