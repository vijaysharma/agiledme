require 'test_helper'

class StoryHistoriesControllerTest < ActionController::TestCase
  setup do
    @story_history = story_histories(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:story_histories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create story_history" do
    assert_difference('StoryHistory.count') do
      post :create, :story_history => @story_history.attributes
    end

    assert_redirected_to story_history_path(assigns(:story_history))
  end

  test "should show story_history" do
    get :show, :id => @story_history.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @story_history.to_param
    assert_response :success
  end

  test "should update story_history" do
    put :update, :id => @story_history.to_param, :story_history => @story_history.attributes
    assert_redirected_to story_history_path(assigns(:story_history))
  end

  test "should destroy story_history" do
    assert_difference('StoryHistory.count', -1) do
      delete :destroy, :id => @story_history.to_param
    end

    assert_redirected_to story_histories_path
  end
end
