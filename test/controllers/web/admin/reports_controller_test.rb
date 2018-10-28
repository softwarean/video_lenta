require 'test_helper'

class Web::Admin::ReportsControllerTest < ActionController::TestCase
  setup do
    @report = create :report
    @user = create :admin
    sign_in @user
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should create report" do
    assert_difference ['Report.count', 'Resque.info[:pending]'] do
      post :create
    end

    assert_redirected_to admin_reports_path
  end

  test "should mark report deleted" do
    assert_difference 'Report.actual.count', -1 do
      delete :destroy, id: @report
    end

    assert_redirected_to admin_reports_path
  end
end
