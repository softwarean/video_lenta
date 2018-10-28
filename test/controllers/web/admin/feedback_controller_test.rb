require 'test_helper'

class Web::Admin::FeedbackControllerTest < ActionController::TestCase
  setup do
    @feedback = create :feedback
    @user = create :admin
    sign_in @user
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get show" do
    get :show, id: @feedback
    assert_response :success
  end

end
