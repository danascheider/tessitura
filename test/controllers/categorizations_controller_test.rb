require 'test_helper'

class CategorizationsControllerTest < ActionController::TestCase
  setup do
    @categorization = categorizations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:categorizations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create categorization" do
    assert_difference('Categorization.count') do
      post :create, categorization: { category_id: @categorization.category_id, todo_id: @categorization.todo_id }
    end

    assert_redirected_to categorization_path(assigns(:categorization))
  end

  test "should show categorization" do
    get :show, id: @categorization
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @categorization
    assert_response :success
  end

  test "should update categorization" do
    patch :update, id: @categorization, categorization: { category_id: @categorization.category_id, todo_id: @categorization.todo_id }
    assert_redirected_to categorization_path(assigns(:categorization))
  end

  test "should destroy categorization" do
    assert_difference('Categorization.count', -1) do
      delete :destroy, id: @categorization
    end

    assert_redirected_to categorizations_path
  end
end
