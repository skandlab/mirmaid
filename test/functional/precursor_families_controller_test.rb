require 'test_helper'

class PrecursorFamiliesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:precursor_families)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create precursor_family" do
    assert_difference('PrecursorFamily.count') do
      post :create, :precursor_family => { }
    end

    assert_redirected_to precursor_family_path(assigns(:precursor_family))
  end

  test "should show precursor_family" do
    get :show, :id => precursor_families(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => precursor_families(:one).id
    assert_response :success
  end

  test "should update precursor_family" do
    put :update, :id => precursor_families(:one).id, :precursor_family => { }
    assert_redirected_to precursor_family_path(assigns(:precursor_family))
  end

  test "should destroy precursor_family" do
    assert_difference('PrecursorFamily.count', -1) do
      delete :destroy, :id => precursor_families(:one).id
    end

    assert_redirected_to precursor_families_path
  end
end
