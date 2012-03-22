class ProjectsController < ApplicationController
  before_filter :find_project, :except => :create

  def import_pivotal_csv

  end

  def upload_pivotal_csv
    file = params[:file]
    old_items = @project.workable_items.count
    FasterCSV.new(file.tempfile, :headers => true).each do |row|
      workable_item = create_workable_item(row)
      import_labels(row, workable_item)
      import_comments(row, workable_item)
      import_tasks(row, workable_item)
      workable_item.save!
    end

    new_items = @project.workable_items.count

    respond_to do |format|
      flash[:notice] = "Successfully imported #{new_items - old_items} items!!"
      format.html { render :template => 'projects/import_pivotal_csv' }
    end

  end

  def get_status(csv_task_status)
    csv_task_status.eql?("completed") ? "finished" : "new"
  end

  def overview
    @project_users = @project.project_users.page(params[:page]).per(10)

    respond_to do |format|
      format.html
      format.xml { render :xml => @project }
    end
  end

  def sprint
    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @project }
    end
  end

  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @project }
    end
  end

  def edit
  end

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

  def update
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
    current_user.join_project(@project)
    respond_to do |format|
      format.js
    end
  end

  def leave
    current_user.leave_project(@project)
    respond_to do |format|
      format.html { redirect_to root_path, :notice => 'You left the project.' }
    end
  end

  def destroy

    @project.destroy

    respond_to do |format|
      format.html { redirect_to root_path, :notice => 'You deleted the project .' }
      format.xml { head :ok }
    end
  end

  private

  def find_project
    @project = Project.find(params[:id])
  end

  def create_workable_item(row)
    csv_state = row['Current State']
    csv_category = parse_category(csv_state)
    workable_item = WorkableItem.new(:project_id => @project.id,
                                     :title => row['Story'],
                                     :description => row['Description'],
                                     :requester => row['Requested By'].present? ? get_existing_or_current_user(row['Requested By']) : current_user.id,
                                     :owner => row['Owned By'].present? ? get_existing_or_current_user(row['Requested By']) : current_user.id,
                                     :status => csv_state == 'unstarted' ? "not_yet_started" : row['Current State'],
                                     :estimate => row['Estimate'].present? ? row['Estimate'].to_i : "",
                                     :category => csv_category,
                                     :priority => get_max_priority_for_category(csv_category) + 1)
    csv_type = row['Story Type'].camelize
    workable_item.type = csv_type.eql?("Feature") ? "Story" : csv_type
    if !csv_state.eql?("unstarted")
      if csv_state.eql?("accepted")
        workable_item.started_at = Time.now
        workable_item.finished_at = Time.now
        workable_item.delivered_at = Time.now
        workable_item.accepted_at = Time.now
      elsif csv_state.eql?("rejected")
        workable_item.started_at = Time.now
        workable_item.finished_at = Time.now
        workable_item.delivered_at = Time.now
        workable_item.rejected_at = Time.now
      elsif csv_state.eql?("delivered")
        workable_item.started_at = Time.now
        workable_item.finished_at = Time.now
        workable_item.delivered_at = Time.now
      elsif csv_state.eql?("finished")
        workable_item.started_at = Time.now
        workable_item.finished_at = Time.now
      elsif csv_state.eql?("started")
        workable_item.started_at = Time.now
      end
    end
    workable_item
  end

  def get_existing_or_current_user(user_name)
    User.find_by_name(user_name).present? ? User.find_by_name(user_name).id : current_user.id
  end

  def parse_category(state)
    state.eql?('unstarted') ? "icebox" : "current"
  end

  def get_max_priority_for_category(category)
    max_priority = @project.workable_items.where(:category => category).maximum(:priority)
    max_priority.present? ? max_priority : 0
  end

  def import_labels(row, workable_item)
    if row['Labels'].present?
      labels = row['Labels'].split(',')
      labels.each do |label|
        workable_item.labels << Label.new(:name => label)
      end
    end
  end

  def import_comments(row, workable_item)
    comment_index = row.index('Comment')
    task_index = row.index('Task')

    (comment_index..(task_index - 1)).each do |index|
      csv_comment = row[index]
      if csv_comment.present?
        comment = csv_comment[0, csv_comment.rindex('(')]
        if comment.present?

          # posted_by_details example : "Sanjeev - Feb 14, 2012"
          posted_by_details = csv_comment.slice((csv_comment.rindex('(') + 1)..(csv_comment.rindex(')') - 1))

          posted_by_user_name = posted_by_details.split('-')[0].strip!
          created_at = DateTime.parse(posted_by_details.split('-')[1].strip!)
          workable_item.comments << Comment.new(:comment => comment,
                                                :posted_by => get_existing_or_current_user(posted_by_user_name),
                                                :created_at => created_at)
        end
      end
    end
  end

  def import_tasks(row, workable_item)
    task_index = row.index('Task')
    skip = false
    (task_index..row.length).each do |index|
      if !skip
        puts index.inspect
        csv_task = row[index]
        if csv_task.present?
          task_status = get_status(row[index + 1])
          new_task = Task.new(:description => csv_task,
                              :created_by => current_user.id,
                              :status => task_status)
          if (task_status.eql?("finished"))
            new_task.finished_by = current_user.id
          end
          workable_item.tasks << new_task
        end
      end
      skip = !skip
    end
  end
end
