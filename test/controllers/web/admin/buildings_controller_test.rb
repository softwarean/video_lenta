require 'test_helper'

class Web::Admin::BuildingsControllerTest < ActionController::TestCase
  setup do
    @user = create :admin
    sign_in @user
    @building = create :building
    @attrs = attributes_for :building, district_id: @building.district_id
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get monitoring" do
    get :monitoring, id: @building
    assert_response :success
  end

  test "should create building" do
    post :create, building: @attrs
    new_building = Building.find_by(name: @attrs[:name])

    assert new_building
    assert_redirected_to admin_buildings_path
  end

  test "should get edit" do
    get :edit, id: @building
    assert_response :success
  end

  test "should update building" do
    patch :update, id: @building, building: @attrs
    new_building = Building.find_by(name: @attrs[:name])

    assert_equal @building, new_building
    assert_redirected_to admin_buildings_path
  end

  test "should destroy building" do
    delete :destroy, id: @building

    assert !Building.exists?(name: @building.name), 'building exists'
    assert_redirected_to admin_buildings_path
  end
end
