require 'test_helper'

class WebApi::BuildingsControllerTest < ActionController::TestCase
  setup do
    @building = create :building
  end

  test "should get index" do
    get :index, format: :json
    assert_response :success
  end

  test "should get show" do
    get :show, id: @building, format: :json
    assert_response :success
  end

end
