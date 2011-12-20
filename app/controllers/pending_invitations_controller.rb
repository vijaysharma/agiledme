class PendingInvitationsController < ApplicationController
  # GET /pending_invitations
  # GET /pending_invitations.xml
  def index
    @pending_invitations = PendingInvitation.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @pending_invitations }
    end
  end

  # GET /pending_invitations/1
  # GET /pending_invitations/1.xml
  def show
    @pending_invitation = PendingInvitation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @pending_invitation }
    end
  end

  # GET /pending_invitations/new
  # GET /pending_invitations/new.xml
  def new
    @pending_invitation = PendingInvitation.new
    @pending_invitation.project = Project.find(params[:project])

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @pending_invitation }
    end
  end

  # GET /pending_invitations/1/edit
  def edit
    @pending_invitation = PendingInvitation.find(params[:id])
  end

  # POST /pending_invitations
  # POST /pending_invitations.xml
  def create
    @pending_invitation = PendingInvitation.new(params[:pending_invitation])

    respond_to do |format|
      if @pending_invitation.save
        format.html { redirect_to(@pending_invitation, :notice => 'Pending invitation was successfully created.') }
        format.xml  { render :xml => @pending_invitation, :status => :created, :location => @pending_invitation }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @pending_invitation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /pending_invitations/1
  # PUT /pending_invitations/1.xml
  def update
    @pending_invitation = PendingInvitation.find(params[:id])

    respond_to do |format|
      if @pending_invitation.update_attributes(params[:pending_invitation])
        format.html { redirect_to(@pending_invitation, :notice => 'Pending invitation was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @pending_invitation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /pending_invitations/1
  # DELETE /pending_invitations/1.xml
  def destroy
    @pending_invitation = PendingInvitation.find(params[:id])
    @pending_invitation.destroy

    respond_to do |format|
      format.html { redirect_to(pending_invitations_url) }
      format.xml  { head :ok }
    end
  end
end
