class WorkableItemsController < ApplicationController

  # POST /workable_items
  # POST /workable_items.xml
  def create
    @project = Project.find(params[:project_id])
    @workable_item = WorkableItem.new(params[:workable_item])
    @workable_item.project = @project
    @workable_item.type = params[:workable_item][:type]

    respond_to do |format|
      if @workable_item.save
        if @workable_item.epic.present? and !@workable_item.epic.split_in_progress?
          @workable_item.epic.start_splitting!
        end
        format.js
        format.html { redirect_to(project_url(@workable_item.project), :notice => @workable_item.type + ' was successfully created.') }
        format.xml { render :xml => @workable_item, :status => :created, :location => @workable_item }
      else
        format.js { render :template => 'workable_items/error' }
        format.html { redirect_to(project_url(@workable_item.project), :notice => @workable_item.type + ' ERROR.') }
        format.xml { render :xml => @workable_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /workable_items/1
  # PUT /workable_items/1.xml
  def update
    @workable_item = WorkableItem.find(params[:id])
    @pre_category = @workable_item.category
    params_req = params[:workable_item] || params[@workable_item.type.downcase]
    @workable_item.type = params_req[:type] || params_req[:type]

    respond_to do |format|
      if @workable_item.update_attributes(params_req)
        @workable_item.update_status_change_history
        @message = "updated"
        format.js { render :template => 'workable_items/action_success' }
        format.html { redirect_to(project_url(@workable_item.project), :notice => @workable_item.type + ' was successfully updated.') }
        format.xml { head :ok }
      else
        format.js { render :template => 'workable_items/error' }
        format.html { redirect_to(project_url(@workable_item.project), :notice => @workable_item.type + ' ERROR.') }
        format.xml { render :xml => @workable_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update_category_and_priority
    @workable_item = WorkableItem.find(params[:id])

    respond_to do |format|
      if @workable_item.prioritize_above(params[:item_dropped_on_id].to_i)
        format.js { render :js => "ajax_flash_notice('Updated successfully!!');" }
      else
        format.html { redirect_to(project_url(@workable_item.project), :notice => @workable_item.type + ' ERROR.') }
        format.xml { render :xml => @workable_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  def start
    @workable_item = WorkableItem.find(params[:id])
    @pre_category = @workable_item.category

    respond_to do |format|
      if @workable_item.start!
        format.js { render :template => 'workable_items/action_success' }
        format.html { redirect_to(project_url(@workable_item.project), :notice => @workable_item.type + ' was successfully started.') }
        format.xml { head :ok }
      else
        format.html { redirect_to(project_url(@workable_item.project), :notice => @workable_item.type + ' ERROR.') }
        format.xml { render :xml => @workable_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  def estimate
    @workable_item = WorkableItem.find(params[:id])
    @message = "estimated as #{params[:estimate]}"

    respond_to do |format|
      if @workable_item.update_attributes(:estimate => params[:estimate])
        @message = "estimated as #{params[:estimate]} pointer"
        format.js { render :template => 'workable_items/action_success' }
        format.html { redirect_to(project_url(@workable_item.project), :notice => @workable_item.type + ' was successfully estimated as a ' + params[:estimate] +" pointer.") }
        format.xml { head :ok }
      else
        format.html { redirect_to(project_url(@workable_item.project), :notice => @workable_item.type + ' ERROR.') }
        format.xml { render :xml => @workable_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  def finish
    @workable_item = WorkableItem.find(params[:id])

    respond_to do |format|
      if @workable_item.finish!
        format.js { render :template => 'workable_items/action_success' }
        format.html { redirect_to(project_url(@workable_item.project), :notice => @workable_item.type + ' was successfully finished.') }
        format.xml { head :ok }
      else
        format.html { redirect_to(project_url(@workable_item.project), :notice => @workable_item.type + ' ERROR.') }
        format.xml { render :xml => @workable_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  def deliver
    @workable_item = WorkableItem.find(params[:id])

    respond_to do |format|
      if @workable_item.deliver!
        format.js { render :template => 'workable_items/action_success' }
        format.html { redirect_to(project_url(@workable_item.project), :notice => @workable_item.type + ' was successfully delivered.') }
        format.xml { head :ok }
      else
        format.html { redirect_to(project_url(@workable_item.project), :notice => @workable_item.type + ' ERROR.') }
        format.xml { render :xml => @workable_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  def accept
    @workable_item = WorkableItem.find(params[:id])
    respond_to do |format|
      if @workable_item.accept!
        format.js { render :template => 'workable_items/action_success' }
        format.html { redirect_to(project_url(@workable_item.project), :notice => @workable_item.type + ' was successfully accepted.') }
        format.xml { head :ok }
      else
        format.html { redirect_to(project_url(@workable_item.project), :notice => @workable_item.type + ' ERROR.') }
        format.xml { render :xml => @workable_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  def reject
    @workable_item = WorkableItem.find(params[:id])

    respond_to do |format|
      if @workable_item.reject!
        format.js { render :template => 'workable_items/action_success' }
        format.html { redirect_to(project_url(@workable_item.project), :notice => @workable_item.type + ' was rejected.') }
        format.xml { head :ok }
      else
        format.html { redirect_to(project_url(@workable_item.project), :notice => @workable_item.type + ' ERROR.') }
        format.xml { render :xml => @workable_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  def restart
    @workable_item = WorkableItem.find(params[:id])

    respond_to do |format|
      if @workable_item.restart!
        format.js { render :template => 'workable_items/action_success' }
        format.html { redirect_to(project_url(@workable_item.project), :notice => @workable_item.type + ' was successfully restarted.') }
        format.xml { head :ok }
      else
        format.html { redirect_to(project_url(@workable_item.project), :notice => @workable_item.type + ' ERROR.') }
        format.xml { render :xml => @workable_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /workable_items/1
  # DELETE /workable_items/1.xml
  def destroy
    @workable_item = WorkableItem.find(params[:id])
    project = @workable_item.project
    @workable_item.destroy

    respond_to do |format|
      format.js
      format.html { redirect_to(project_url(project), :notice => @workable_item.type + ' was successfully deleted.') }
      format.xml { head :ok }
    end
  end
end
