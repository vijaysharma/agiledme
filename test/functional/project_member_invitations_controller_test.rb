require 'test_helper'

class ProjectMemberInvitationsControllerTest < ActionController::TestCase
  setup do
    @project_member_invitation = pending_invitations(:one)
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

  test "should create project_member_invitation" do
    assert_difference('PendingInvitation.count') do
      post :create, :project_member_invitation => @project_member_invitation.attributes
    end

    assert_redirected_to pending_invitation_path(assigns(:project_member_invitation))
  end

  test "should show project_member_invitation" do
    get :show, :id => @project_member_invitation.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @project_member_invitation.to_param
    assert_response :success
  end

  test "should update project_member_invitation" do
    put :update, :id => @project_member_invitation.to_param, :project_member_invitation => @project_member_invitation.attributes
    assert_redirected_to pending_invitation_path(assigns(:project_member_invitation))
  end

  test "should destroy project_member_invitation" do
    assert_difference('PendingInvitation.count', -1) do
      delete :destroy, :id => @project_member_invitation.to_param
    end

    assert_redirected_to project_member_invitations_path
  end
end
