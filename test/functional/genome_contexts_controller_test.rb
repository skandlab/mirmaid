require 'test_helper'

class GenomeContextsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:genome_contexts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create genome_context" do
    assert_difference('GenomeContext.count') do
      post :create, :genome_context => { }
    end

    assert_redirected_to genome_context_path(assigns(:genome_context))
  end

  test "should show genome_context" do
    get :show, :id => genome_contexts(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => genome_contexts(:one).id
    assert_response :success
  end

  test "should update genome_context" do
    put :update, :id => genome_contexts(:one).id, :genome_context => { }
    assert_redirected_to genome_context_path(assigns(:genome_context))
  end

  test "should destroy genome_context" do
    assert_difference('GenomeContext.count', -1) do
      delete :destroy, :id => genome_contexts(:one).id
    end

    assert_redirected_to genome_contexts_path
  end
end
