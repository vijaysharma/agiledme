require 'test_helper'

class PendingInvitationsControllerTest < ActionController::TestCase
  setup do
    @pending_invitation = pending_invitations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:pending_invitations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create pending_invitation" do
    assert_difference('PendingInvitation.count') do
      post :create, :pending_invitation => @pending_invitation.attributes
    end

    assert_redirected_to pending_invitation_path(assigns(:pending_invitation))
  end

  test "should show pending_invitation" do
    get :show, :id => @pending_invitation.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @pending_invitation.to_param
    assert_response :success
  end

  test "should update pending_invitation" do
    put :update, :id => @pending_invitation.to_param, :pending_invitation => @pending_invitation.attributes
    assert_redirected_to pending_invitation_path(assigns(:pending_invitation))
  end

  test "should destroy pending_invitation" do
    assert_difference('PendingInvitation.count', -1) do
      delete :destroy, :id => @pending_invitation.to_param
    end

    assert_redirected_to pending_invitations_path
  end
end
