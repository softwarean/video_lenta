require 'test_helper'

class Web::BuildingsControllerTest < ActionController::TestCase
  setup do
    @building = create :building
  end

  test "should get show" do
    get :show, id: @building
    assert_response :success
  end
end
