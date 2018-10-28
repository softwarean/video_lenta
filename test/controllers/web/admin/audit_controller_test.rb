require 'test_helper'

class Web::Admin::AuditControllerTest < ActionController::TestCase
  setup do
    @user = create :admin
    sign_in @user
  end

  test "should get show" do
    get :index
    assert_response :success
  end
end
