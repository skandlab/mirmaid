require 'test_helper'

class SeedFamiliesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:seed_families)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create seed_family" do
    assert_difference('SeedFamily.count') do
      post :create, :seed_family => { }
    end

    assert_redirected_to seed_family_path(assigns(:seed_family))
  end

  test "should show seed_family" do
    get :show, :id => seed_families(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => seed_families(:one).id
    assert_response :success
  end

  test "should update seed_family" do
    put :update, :id => seed_families(:one).id, :seed_family => { }
    assert_redirected_to seed_family_path(assigns(:seed_family))
  end

  test "should destroy seed_family" do
    assert_difference('SeedFamily.count', -1) do
      delete :destroy, :id => seed_families(:one).id
    end

    assert_redirected_to seed_families_path
  end
end
