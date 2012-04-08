class EpicsController < ApplicationController
  # GET /epics
  # GET /epics.xml
  def index
    @project = current_user.projects.find(params[:project])
    @epics = @project.epics

    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @epics }
    end
  end

  # GET /epics/1
  # GET /epics/1.xml
  def show
    @epic = Epic.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @epic }
    end
  end

  # GET /epics/new
  # GET /epics/new.xml
  def new
    @epic = Epic.new
    @epic.project = current_user.projects.find(params[:project])
    @epic.user_id = current_user.id

    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @epic }
    end
  end

  # GET /epics/1/edit
  def edit
    @epic = Epic.find(params[:id])
  end

  # POST /epics
  # POST /epics.xml
  def create
    @epic = Epic.new(params[:epic])

    respond_to do |format|
      if @epic.save
        format.html { redirect_to(project_path(@epic.project), :notice => 'Epic was successfully created.') }
        format.xml { render :xml => @epic, :status => :created, :location => @epic }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @epic.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /epics/1
  # PUT /epics/1.xml
  def update
    @epic = Epic.find(params[:id])

    respond_to do |format|
      if @epic.update_attributes(params[:epic])
        format.html { redirect_to(project_path(@epic.project),  :notice => 'Epic was successfully updated.') }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @epic.errors, :status => :unprocessable_entity }
      end
    end
  end

  def finish
    @epic = Epic.find(params[:id])

    respond_to do |format|
      if @epic.finish!
        format.html { redirect_to(project_url(@epic.project), :notice => 'Epic was successfully finished.') }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @epic.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /epics/1
  # DELETE /epics/1.xml
  def destroy
    @epic = Epic.find(params[:id])
    project = @epic.project
    @epic.destroy

    respond_to do |format|
      format.html { redirect_to(project_path(project), :notice => 'Epic was successfully deleted.') }
      format.xml { head :ok }
    end
  end
end
