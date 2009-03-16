require 'test_helper'

class PrecursorClustersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:precursor_clusters)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create precursor_cluster" do
    assert_difference('PrecursorCluster.count') do
      post :create, :precursor_cluster => { }
    end

    assert_redirected_to precursor_cluster_path(assigns(:precursor_cluster))
  end

  test "should show precursor_cluster" do
    get :show, :id => precursor_clusters(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => precursor_clusters(:one).id
    assert_response :success
  end

  test "should update precursor_cluster" do
    put :update, :id => precursor_clusters(:one).id, :precursor_cluster => { }
    assert_redirected_to precursor_cluster_path(assigns(:precursor_cluster))
  end

  test "should destroy precursor_cluster" do
    assert_difference('PrecursorCluster.count', -1) do
      delete :destroy, :id => precursor_clusters(:one).id
    end

    assert_redirected_to precursor_clusters_path
  end
end
