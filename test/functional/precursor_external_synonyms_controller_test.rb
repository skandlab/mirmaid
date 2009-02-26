require 'test_helper'

class PrecursorExternalSynonymsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:precursor_external_synonyms)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create precursor_external_synonym" do
    assert_difference('PrecursorExternalSynonym.count') do
      post :create, :precursor_external_synonym => { }
    end

    assert_redirected_to precursor_external_synonym_path(assigns(:precursor_external_synonym))
  end

  test "should show precursor_external_synonym" do
    get :show, :id => precursor_external_synonyms(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => precursor_external_synonyms(:one).id
    assert_response :success
  end

  test "should update precursor_external_synonym" do
    put :update, :id => precursor_external_synonyms(:one).id, :precursor_external_synonym => { }
    assert_redirected_to precursor_external_synonym_path(assigns(:precursor_external_synonym))
  end

  test "should destroy precursor_external_synonym" do
    assert_difference('PrecursorExternalSynonym.count', -1) do
      delete :destroy, :id => precursor_external_synonyms(:one).id
    end

    assert_redirected_to precursor_external_synonyms_path
  end
end
