require 'test_helper'

class Web::Admin::SessionsControllerTest < ActionController::TestCase
  setup do
    @user = create :user
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should sign in user" do
    session_params = {email: @user.email, password: @user.password}

    post :create, session: session_params

    assert_equal @user, current_user

    assert_redirected_to :admin_root
  end

  test "should not sign in user with wrong password" do
    user_attrs = attributes_for :user

    session_params = {email: @user.email, password: user_attrs[:password]}

    post :create, session: session_params

    assert_not_equal @user, current_user

    assert_response :success
  end

  test "should sign out user" do
    sign_in @user

    delete :destroy

    assert_not signed_in?, "user haven't signed out"

    assert_redirected_to new_admin_session_path
  end
end
