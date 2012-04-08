class StoriesController < ApplicationController

  before_filter :find_story_and_set_project, :except => :create

  # POST /stories
  # POST /stories.xml
  def create
    @project = current_user.projects.find(params[:project_id])
    @story = get_story_object(params[:story][:type])
    @story.project = @project

    @story.story_attachments = StoryAttachment.where(:user_id => current_user.id, :story_id => nil)
    respond_to do |format|
      if @story.save
        format.js
        format.html { redirect_to(project_url(@story.project), :notice => @story.type + ' was successfully created.') }
        format.xml { render :xml => @story, :status => :created, :location => @story }
      else
        format.js { render :template => 'stories/error' }
        format.html { redirect_to(project_url(@story.project), :notice => @story.type + ' ERROR.') }
        format.xml { render :xml => @story.errors, :status => :unprocessable_entity }
      end
    end
  end

  def get_story_object(type)
    if type == "Feature"
      Feature.new(params[:story])
    elsif type == "Bug"
      Bug.new(params[:story])
    elsif type == "Chore"
      Chore.new(params[:story])
    elsif type == "Epic"
      Epic.new(params[:story])
    end
  end

  # PUT /stories/1
  # PUT /stories/1.xml
  def update
    @pre_category = @story.category
    params_req = params[:story] || params[@story.type.downcase]
    @story.type = params_req[:type] || params_req[:type]

    respond_to do |format|
      if @story.update_attributes(params_req)
        @story.update_status_change_history
        @message = "#{@story.type} was updated"
        @story.story_attachments.reload
        format.js { render :template => 'stories/action_success' }
        format.html { redirect_to(project_url(@story.project), :notice => @story.type + ' was successfully updated.') }
        format.xml { head :ok }
      else
        format.js { render :template => 'stories/error' }
        format.html { redirect_to(project_url(@story.project), :notice => @story.type + ' ERROR.') }
        format.xml { render :xml => @story.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update_category_and_priority

    respond_to do |format|
      if @story.prioritize_above(params[:item_dropped_on_id].to_i)
        format.js { render :js => "ajax_flash_notice('Updated successfully!!');" }
      else
        format.html { redirect_to(project_url(@story.project), :notice => @story.type + ' ERROR.') }
        format.xml { render :xml => @story.errors, :status => :unprocessable_entity }
      end
    end
  end

  def start
    @pre_category = @story.category

    respond_to do |format|
      if @story.start!
        format.js { render :template => 'stories/action_success' }
        format.html { redirect_to(project_url(@story.project), :notice => @story.type + ' was successfully started.') }
        format.xml { head :ok }
      else
        format.html { redirect_to(project_url(@story.project), :notice => @story.type + ' ERROR.') }
        format.xml { render :xml => @story.errors, :status => :unprocessable_entity }
      end
    end
  end

  def un_start
    respond_to do |format|
      if @story.un_start!
        @message = "Rolled back #{@story.type} start."
        format.js { render :template => 'stories/action_success' }
        format.html { redirect_to(project_url(@story.project), :notice => 'Rolled back '+@story.type + ' start.') }
        format.xml { head :ok }
      else
        format.html { redirect_to(project_url(@story.project), :notice => @story.type + ' ERROR.') }
        format.xml { render :xml => @story.errors, :status => :unprocessable_entity }
      end
    end
  end

  def estimate
    @message = "#{@story.type} was estimated as #{params[:estimate]}"

    respond_to do |format|
      if @story.update_attributes(:estimate => params[:estimate])
        @message = "#{@story.type} was estimated as #{params[:estimate]} pointer"
        format.js { render :template => 'stories/action_success' }
        format.html { redirect_to(project_url(@story.project), :notice => @story.type + ' was successfully estimated as a ' + params[:estimate] +" pointer.") }
        format.xml { head :ok }
      else
        format.html { redirect_to(project_url(@story.project), :notice => @story.type + ' ERROR.') }
        format.xml { render :xml => @story.errors, :status => :unprocessable_entity }
      end
    end
  end

  def finish
    respond_to do |format|
      if @story.finish!
        format.js { render :template => 'stories/action_success' }
        format.html { redirect_to(project_url(@story.project), :notice => @story.type + ' was successfully finished.') }
        format.xml { head :ok }
      else
        format.html { redirect_to(project_url(@story.project), :notice => @story.type + ' ERROR.') }
        format.xml { render :xml => @story.errors, :status => :unprocessable_entity }
      end
    end
  end

  def un_finish
    respond_to do |format|
      if @story.un_finish!
        @message = "Rolled back #{@story.type} finish."
        format.js { render :template => 'stories/action_success' }
        format.html { redirect_to(project_url(@story.project), :notice => 'Rolled back '+@story.type + ' finish.') }
        format.xml { head :ok }
      else
        format.html { redirect_to(project_url(@story.project), :notice => @story.type + ' ERROR.') }
        format.xml { render :xml => @story.errors, :status => :unprocessable_entity }
      end
    end
  end

  def deliver
    respond_to do |format|
      if @story.deliver!
        format.js { render :template => 'stories/action_success' }
        format.html { redirect_to(project_url(@story.project), :notice => @story.type + ' was successfully delivered.') }
        format.xml { head :ok }
      else
        format.html { redirect_to(project_url(@story.project), :notice => @story.type + ' ERROR.') }
        format.xml { render :xml => @story.errors, :status => :unprocessable_entity }
      end
    end
  end

  def un_deliver
    respond_to do |format|
      if @story.un_deliver!
        @message = "Rolled back #{@story.type} deliver."
        format.js { render :template => 'stories/action_success' }
        format.html { redirect_to(project_url(@story.project), :notice => 'Rolled back '+@story.type + ' delivery.') }
        format.xml { head :ok }
      else
        format.html { redirect_to(project_url(@story.project), :notice => @story.type + ' ERROR.') }
        format.xml { render :xml => @story.errors, :status => :unprocessable_entity }
      end
    end
  end

  def accept
    respond_to do |format|
      if @story.accept!
        format.js { render :template => 'stories/action_success' }
        format.html { redirect_to(project_url(@story.project), :notice => @story.type + ' was successfully accepted.') }
        format.xml { head :ok }
      else
        format.html { redirect_to(project_url(@story.project), :notice => @story.type + ' ERROR.') }
        format.xml { render :xml => @story.errors, :status => :unprocessable_entity }
      end
    end
  end

  def reject
    respond_to do |format|
      if @story.reject!
        format.js { render :template => 'stories/action_success' }
        format.html { redirect_to(project_url(@story.project), :notice => @story.type + ' was rejected.') }
        format.xml { head :ok }
      else
        format.html { redirect_to(project_url(@story.project), :notice => @story.type + ' ERROR.') }
        format.xml { render :xml => @story.errors, :status => :unprocessable_entity }
      end
    end
  end

  def restart
    respond_to do |format|
      if @story.restart!
        format.js { render :template => 'stories/action_success' }
        format.html { redirect_to(project_url(@story.project), :notice => @story.type + ' was successfully restarted.') }
        format.xml { head :ok }
      else
        format.html { redirect_to(project_url(@story.project), :notice => @story.type + ' ERROR.') }
        format.xml { render :xml => @story.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /stories/1
  # DELETE /stories/1.xml
  def destroy
    @story.destroy

    respond_to do |format|
      format.js
      format.html { redirect_to(project_url(@project), :notice => @story.type + ' was successfully deleted.') }
      format.xml { head :ok }
    end
  end

  private

  def find_story_and_set_project
    @story = Story.find(params[:id])
    @project = @story.project
  end

  def prepare_attachments
    attachments = []
    params[:story][:story_attachments_attributes].each do |index, image|
      image[:image].each do |file|
        attachments << {:image => file, :user_id => current_user.id}
      end
    end
    params[:story][:story_attachments_attributes] = attachments
  end

end
