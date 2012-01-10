class ProjectMemberInvitationsController < ApplicationController
  def index
    @project = Project.find(params[:project_id])
    @project_member_invitations = @project.project_member_invitations

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @project_member_invitations }
    end
  end

  def new
    @project_member_invitation = ProjectMemberInvitation.new
    @project_member_invitation.project = Project.find(params[:project_id])
    @project_member_invitation.invited_by = current_user.id

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @project_member_invitation }
    end
  end

  def edit
    @project_member_invitation = ProjectMemberInvitation.find(params[:id])
  end

  def create
    @project_member_invitation = ProjectMemberInvitation.new(params[:project_member_invitation])

    respond_to do |format|
      if @project_member_invitation.save
        format.js
        format.html { redirect_to(project_member_invitations_path(:project => @project_member_invitation.project), :notice => 'Invitation was successfully created.') }
        format.xml  { render :xml => @project_member_invitation, :status => :created, :location => @project_member_invitation }
      else

        format.html { render :action => "new" }
        format.xml  { render :xml => @project_member_invitation.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @project_member_invitation = ProjectMemberInvitation.find(params[:id])

    respond_to do |format|
      if @project_member_invitation.update_attributes(params[:project_member_invitation])
        format.html { redirect_to(project_member_invitations_path(:project => @project_member_invitation.project), :notice => 'Invitation was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @project_member_invitation.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @project_member_invitation = ProjectMemberInvitation.find(params[:id])
    project = @project_member_invitation.project
    @project_member_invitation.destroy

    respond_to do |format|
      format.html { redirect_to(project_member_invitations_url(:project => project), :notice => 'Invitation was successfully deleted.') }
      format.xml  { head :ok }
    end
  end
end
