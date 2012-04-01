require 'test_helper'

class WorkableItemsControllerTest < ActionController::TestCase
  setup do
    @workable_item = workable_items(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:workable_items)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create workable_item" do
    assert_difference('Feature.count') do
      post :create, :workable_item => @workable_item.attributes
    end

    assert_redirected_to story_path(assigns(:workable_item))
  end

  test "should show workable_item" do
    get :show, :id => @workable_item.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @workable_item.to_param
    assert_response :success
  end

  test "should update workable_item" do
    put :update, :id => @workable_item.to_param, :workable_item => @workable_item.attributes
    assert_redirected_to story_path(assigns(:workable_item))
  end

  test "should destroy workable_item" do
    assert_difference('Feature.count', -1) do
      delete :destroy, :id => @workable_item.to_param
    end

    assert_redirected_to workable_items_path
  end
end
