require 'test_helper'

class WebApi::DistrictsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index, format: :json
    assert_response :success
  end

end
