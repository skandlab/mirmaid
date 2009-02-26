require 'test_helper'

class GenomePositionsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:genome_positions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create genome_position" do
    assert_difference('GenomePosition.count') do
      post :create, :genome_position => { }
    end

    assert_redirected_to genome_position_path(assigns(:genome_position))
  end

  test "should show genome_position" do
    get :show, :id => genome_positions(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => genome_positions(:one).id
    assert_response :success
  end

  test "should update genome_position" do
    put :update, :id => genome_positions(:one).id, :genome_position => { }
    assert_redirected_to genome_position_path(assigns(:genome_position))
  end

  test "should destroy genome_position" do
    assert_difference('GenomePosition.count', -1) do
      delete :destroy, :id => genome_positions(:one).id
    end

    assert_redirected_to genome_positions_path
  end
end
