class ProjectMemberInvitationsController < ApplicationController
  def index
    @project = Project.find(params[:project_id])

    respond_to do |format|
      format.html
    end
  end

  def create
    @project = Project.find(params[:project_id])
    invitee_details = get_invitee_details(params[:project_member_invitation][:invitee_details])

    user = User.find_by_email(invitee_details[:email])
    if is_new_user_in_system?(user)
      @user = User.invite!(invitee_details, current_user)
      @project_user = ProjectUser.create!(:user_id => @user.id, :project_id => @project.id, :active => false, :role => params[:project_member_invitation][:role])
      @message = "An invite is sent to #{invitee_details[:name] || invitee_details[:email]} to join the project!"

    elsif has_already_joined_the_project?(user)
      @error = "#{user.name || user.email} is already #{user.role} of the project!"

    elsif is_invited_but_not_joined_the_project?(user)
      send_project_join_request_to_user(invitee_details)
      @user = user
      @message = "Resent invite to #{user.name || user.email} to join the project!"

    else
      # user is there in the system already, but not invited for this project ever, so invite him now
      @user = user
      @project_user = ProjectUser.create!(:user_id => user.id, :project_id => @project.id, :active => false)
      send_project_join_request_to_user(invitee_details)
      @message = "An invite is sent to #{user.name || user.email} to join the project!"
    end


    respond_to do |format|
      format.js
    end
  end

  def update
    @project_member_invitation = ProjectMemberInvitation.find(params[:id])

    respond_to do |format|
      if @project_member_invitation.update_attributes(params[:project_member_invitation])
        format.html { redirect_to(project_member_invitations_path(:project => @project_member_invitation.project), :notice => 'Invitation was successfully updated.') }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @project_member_invitation.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @project_member_invitation = ProjectMemberInvitation.find(params[:id])
    project = @project_member_invitation.project
    @project_member_invitation.destroy

    respond_to do |format|
      format.html { redirect_to(project_member_invitations_url(:project => project), :notice => 'Invitation was successfully deleted.') }
      format.xml { head :ok }
    end
  end

  private

  def get_invitee_details(invitee_details_value)

    name = ""
    email = ""
    initials = ""
    if (invitee_details_value.include?('<'))
      name = invitee_details_value.split('<')[0].split('(')[0]
      initials = invitee_details_value.split('<')[0].split('(')[1].split(')')[0]
      email = invitee_details_value.split('<')[1].split('>')[0]
    elsif invitee_details_value.include?(',')
      name = invitee_details_value.split(',')[0].strip
      email = invitee_details_value.split(',')[1]
    end
    {:initials => initials.strip, :email => email.strip, :name => name.strip}
  end

  def has_already_joined_the_project?(user)
    @project.active_users.include? user
  end

  def is_invited_but_not_joined_the_project?(user)
    @project.inactive_users.include? user
  end

  def send_project_join_request_to_user(invitee_details)

  end

  def is_new_user_in_system?(user)
    user.blank?
  end


end