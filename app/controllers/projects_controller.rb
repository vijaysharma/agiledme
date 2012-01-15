class ProjectsController < ApplicationController

  def overview
    @project = Project.find(params[:id])
    @project_users = @project.project_users.page(params[:page]).per(10)

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @project }
    end
  end

  # GET /projects/1
  # GET /projects/1.xml
  def show
    @project = Project.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @project }
    end
  end

  # GET /projects/1/edit
  def edit
    @project = Project.find(params[:id])
  end

  # POST /projects
  # POST /projects.xml
  def create
    @project = Project.new(params[:project])
    @project.project_users << ProjectUser.new(:user_id => current_user.id, :project_id => @project.id, :active => true, :role => "owner")
    respond_to do |format|
      if @project.save
        format.js
      else
        format.xml { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /projects/1
  # PUT /projects/1.xml
  def update
    @project = Project.find(params[:id])

    respond_to do |format|
      if @project.update_attributes(params[:project])
        format.html { redirect_to overview_project_path(@project), :notice => 'Project was successfully updated.' }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  def join
    @project = Project.find(params[:id])
    current_user.join_project(@project)
    respond_to do |format|
        format.js
    end
  end


  def leave
    @project = Project.find(params[:id])
    current_user.leave_project(@project)
    respond_to do |format|
        format.html { redirect_to root_path, :notice => 'You left the project.' }
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.xml
  def destroy
    @project = Project.find(params[:id])
    @project.destroy

    respond_to do |format|
      format.html { redirect_to root_path, :notice => 'You deleted the project .' }
      format.xml { head :ok }
    end
  end
end
