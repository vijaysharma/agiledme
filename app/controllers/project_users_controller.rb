class ProjectUsersController < ApplicationController
  def index
    @project = Project.find(params[:project_id])

    respond_to do |format|
      format.html
    end
  end

  def create
    @project = Project.find(params[:project_id])
    invitee_details = get_invitee_details(params[:project_user][:invitee_details])

    if @error.blank?
      user = User.find_by_email(invitee_details[:email])
      if is_new_user_in_system?(user)
        @user = User.invite!(invitee_details, current_user)
        @project_user = ProjectUser.create!(:user_id => @user.id, :project_id => @project.id, :active => false, :role => params[:project_user][:role])
        @message = "An invite is sent to #{invitee_details[:name] || invitee_details[:email]} to join the project!"

      elsif user.not_accepted_the_invitation?
        @user = User.invite!(invitee_details, current_user)
        if is_not_invited_for_the_project?(user)
          @project_user = ProjectUser.create!(:user_id => @user.id, :project_id => @project.id, :active => false, :role => params[:project_user][:role])
        end
        @message = "An invite is sent to #{invitee_details[:name] || invitee_details[:email]} to join the project!"

      elsif has_already_joined_the_project?(user)
        @error = "#{user.name || user.email} is already #{user.project_users.where(:project_id => @project.id).first.role} of the project!"

      elsif is_invited_but_not_joined_the_project?(user)
        @user = user
        send_project_join_request_to_user
        @message = "Resent invite to #{user.name || user.email} to join the project!"

      elsif
        # user is there in the system already, but not invited for this project ever, so invite him now
      @user = user
        @project_user = ProjectUser.create!(:user_id => user.id, :project_id => @project.id, :active => false, :role => params[:project_user][:role])
        send_project_join_request_to_user
        @message = "An invite is sent to #{user.name || user.email} to join the project!"
      end
    end

    respond_to do |format|
      format.js
    end
  end

  def update
    @project_user = ProjectUser.find(params[:id])

    respond_to do |format|
      if @project_user.update_attributes(params[:project_user])
        format.html { redirect_to(project_users_path(:project => @project_user.project), :notice => 'Invitation was successfully updated.') }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @project_user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    project_user = ProjectUser.find(params[:id])
    @user = project_user.user
    project_user.destroy

    respond_to do |format|
      format.js
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
    else
      return @error = "Wrong format! Please enter the details as mentioned below in the example."
    end

    {:initials => initials.strip, :email => email.strip, :name => name.strip}

  end

  def has_already_joined_the_project?(user)
    @project.active_users.include? user
  end

  def is_not_invited_for_the_project?(user)
    !@project.users.include? user
  end

  def is_invited_but_not_joined_the_project?(user)
    @project.inactive_users.include? user
  end

  def send_project_join_request_to_user
    UserMailer.delay.join_project_invitation(@user, @project, current_user)
  end

  def is_new_user_in_system?(user)
    user.blank?
  end
end