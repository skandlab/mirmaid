require 'test_helper'

class MaturesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:matures)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create mature" do
    assert_difference('Mature.count') do
      post :create, :mature => { }
    end

    assert_redirected_to mature_path(assigns(:mature))
  end

  test "should show mature" do
    get :show, :id => matures(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => matures(:one).id
    assert_response :success
  end

  test "should update mature" do
    put :update, :id => matures(:one).id, :mature => { }
    assert_redirected_to mature_path(assigns(:mature))
  end

  test "should destroy mature" do
    assert_difference('Mature.count', -1) do
      delete :destroy, :id => matures(:one).id
    end

    assert_redirected_to matures_path
  end
end
