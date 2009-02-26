require 'test_helper'

class PrecursorsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:precursors)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create precursor" do
    assert_difference('Precursor.count') do
      post :create, :precursor => { }
    end

    assert_redirected_to precursor_path(assigns(:precursor))
  end

  test "should show precursor" do
    get :show, :id => precursors(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => precursors(:one).id
    assert_response :success
  end

  test "should update precursor" do
    put :update, :id => precursors(:one).id, :precursor => { }
    assert_redirected_to precursor_path(assigns(:precursor))
  end

  test "should destroy precursor" do
    assert_difference('Precursor.count', -1) do
      delete :destroy, :id => precursors(:one).id
    end

    assert_redirected_to precursors_path
  end
end
