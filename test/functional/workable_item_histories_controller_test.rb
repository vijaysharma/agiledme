require 'test_helper'

class WorkableItemHistoriesControllerTest < ActionController::TestCase
  setup do
    @workable_item_history = workable_item_histories(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:workable_item_histories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create workable_item_history" do
    assert_difference('WorkableItemHistory.count') do
      post :create, :workable_item_history => @workable_item_history.attributes
    end

    assert_redirected_to story_history_path(assigns(:workable_item_history))
  end

  test "should show workable_item_history" do
    get :show, :id => @workable_item_history.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @workable_item_history.to_param
    assert_response :success
  end

  test "should update workable_item_history" do
    put :update, :id => @workable_item_history.to_param, :workable_item_history => @workable_item_history.attributes
    assert_redirected_to workable_item_history_path(assigns(:workable_item_history))
  end

  test "should destroy workable_item_history" do
    assert_difference('WorkableItemHistory.count', -1) do
      delete :destroy, :id => @workable_item_history.to_param
    end

    assert_redirected_to workable_item_histories_path
  end
end
