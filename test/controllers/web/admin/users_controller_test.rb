require 'test_helper'

class Web::Admin::UsersControllerTest < ActionController::TestCase
  setup do
    @user = create :admin
    sign_in @user
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user" do
    user_attributes = attributes_for :user
    post :create, user: user_attributes
    new_user = User.find_by(email: user_attributes[:email])

    assert new_user
    assert_redirected_to admin_users_path
  end

  test "should get edit" do
    get :edit, id: @user
    assert_response :success
  end

  test "should update user" do
    user_attributes = attributes_for :user
    patch :update, id: @user, user: user_attributes
    new_user = User.find_by(email: user_attributes[:email])

    assert_equal @user, new_user
    assert_redirected_to admin_users_path
  end

  test "should destroy user" do
    delete :destroy, id: @user

    assert !User.exists?(email: @user.email), 'user exists'
    assert_redirected_to admin_users_path
  end
end
