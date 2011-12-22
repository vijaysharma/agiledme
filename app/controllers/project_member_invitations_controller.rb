class ProjectMemberInvitationsController < ApplicationController
  # GET /pending_invitations
  # GET /pending_invitations.xml
  def index
    @project = Project.find(params[:project])
    @project_member_invitations = @project.project_member_invitations

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @project_member_invitations }
    end
  end

  # GET /pending_invitations/1
  # GET /pending_invitations/1.xml
  def show
    @project_member_invitation = ProjectMemberInvitation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @project_member_invitation }
    end
  end

  # GET /pending_invitations/new
  # GET /pending_invitations/new.xml
  def new
    @project_member_invitation = ProjectMemberInvitation.new
    @project_member_invitation.project = Project.find(params[:project])
    @project_member_invitation.invited_by = current_user.id

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @project_member_invitation }
    end
  end

  # GET /pending_invitations/1/edit
  def edit
    @project_member_invitation = ProjectMemberInvitation.find(params[:id])
  end

  # POST /pending_invitations
  # POST /pending_invitations.xml
  def create
    @project_member_invitation = ProjectMemberInvitation.new(params[:project_member_invitation])

    respond_to do |format|
      if @project_member_invitation.save
        format.html { redirect_to(@project_member_invitation, :notice => 'Invitation was successfully created.') }
        format.xml  { render :xml => @project_member_invitation, :status => :created, :location => @project_member_invitation }
      else

        format.html { render :action => "new" }
        format.xml  { render :xml => @project_member_invitation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /pending_invitations/1
  # PUT /pending_invitations/1.xml
  def update
    @project_member_invitation = ProjectMemberInvitation.find(params[:id])

    respond_to do |format|
      if @project_member_invitation.update_attributes(params[:project_member_invitation])
        format.html { redirect_to(@project_member_invitation, :notice => 'Invitation was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @project_member_invitation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /pending_invitations/1
  # DELETE /pending_invitations/1.xml
  def destroy
    @project_member_invitation = ProjectMemberInvitation.find(params[:id])
    @project_member_invitation.destroy

    respond_to do |format|
      format.html { redirect_to(project_member_invitations_url) }
      format.xml  { head :ok }
    end
  end
end
