class ProjectsController < ApplicationController
  require 'csv'
  before_filter :find_project, :except => :create

  def search
    @search_term = params[:search_term]
    @scope = params[:scope]
    respond_to do |format|
      if @search_term.present? and @search_term.length > 2
        if @scope.eql?("sprint")
          @workable_items = @project.workable_items(:include => [:comments, :tasks]).where(:category => "current")
        else
          @workable_items = @project.workable_items(:include => [:comments, :tasks])
        end

        if @workable_items.present?
          if is_search_by_owner?
            @search_results = get_items_for_owner(@search_term.split(':')[1])
          elsif is_search_by_label?
            @search_results = get_items_for_label(@search_term.split(':')[1])
          else
            @search_results = get_items_for(@search_term)

            owner_results = get_items_for_owner(@search_term)
            label_results = get_items_for_label(@search_term)
            comment_results = get_items_for_comments(@search_term)
            task_results = get_items_for_tasks(@search_term)

            if @search_results.present?
              if owner_results.present?
                @search_results = @search_results + owner_results
              end
            else
              @search_results = get_items_for_owner(@search_term)
            end

            if @search_results.present?
              if label_results.present?
                @search_results = @search_results + label_results
              end
            else
              @search_results = label_results
            end

            if @search_results.present?
              if comment_results.present?
                @search_results = @search_results + comment_results
              end
            else
              @search_results = comment_results
            end

            if @search_results.present?
              if task_results.present?
                @search_results = @search_results + task_results
              end
            else
              @search_results = task_results
            end
          end
        else
          @search_results = nil
        end
      else
        @error = "Please enter minimum 3 letters to search!"
      end
      format.js
    end
  end

  def import_pivotal_csv
  end

  def upload_pivotal_csv

    respond_to do |format|
      if params[:file].present?
        old_items = @project.workable_items.count
        file = IO.read(params[:file].tempfile.path)

        CSV.new(file, :headers => true).each do |row|
          csv_type = row['Story Type']
          #importing release is not supported as of today (22 March 2012)
          if !csv_type.eql?("release")
            workable_item = create_workable_item(row)
            import_labels(row, workable_item)
            import_comments(row, workable_item)
            import_tasks(row, workable_item)
            workable_item.save!
          end
        end

        new_items = @project.workable_items.count
        flash[:notice] = "Successfully imported #{new_items - old_items} items!!"
        format.html { render :template => 'projects/import_pivotal_csv' }
      else
        flash[:notice] = "ERROR!! Please select a CSV to import!!"
        format.html { render :template => 'projects/import_pivotal_csv' }
      end
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
    @project_users = @project.active_users
    respond_to do |format|
      format.html
      format.xml { render :xml => @project }
    end
  end

  def show_more_items
    @category = params[:category]
    @workable_items_to_append = @project.workable_items.where(:category => params[:category]).limit(15).offset(params[:offset])
    respond_to do |format|
      format.js
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
    csv_type = row['Story Type'].camelize
    workable_item = WorkableItem.new(:project_id => @project.id,
                                     :title => row['Story'],
                                     :description => row['Description'],
                                     :requester => row['Requested By'].present? ? get_existing_or_current_user(row['Requested By']) : current_user.id,
                                     :status => (csv_state.eql?('unstarted') || csv_state.eql?('unscheduled')) ? "not_yet_started" : row['Current State'],
                                     :category => csv_category,
                                     :estimate => (csv_type.eql?("Feature") and row['Estimate'].present?) ? row['Estimate'].to_i : -1,
                                     :priority => get_max_priority_for_category(csv_category) + 1)


    workable_item.type = csv_type.eql?("Feature") ? "Story" : csv_type

    if row['Owned By'].present?
      workable_item.owner = get_existing_or_current_user(row['Owned By'])
    end

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
    if state.eql?('accepted')
      "done"
    elsif (state.eql?('unstarted') || state.eql?('unscheduled'))
      "icebox"
    else
      "current"
    end
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

  def is_search_by_owner?
    search_term_prefix = @search_term.split(':')[0]
    search_term_prefix.present? and search_term_prefix.eql?("mywork")
  end

  def is_search_by_label?
    search_term_prefix = @search_term.split(':')[0]
    search_term_prefix.present? and search_term_prefix.eql?("label")
  end

  def get_items_for_owner(search_term)
    if search_term.present?
      owner = User.where("initials = ? or name = ? or email = ?", search_term, search_term, search_term).first
      if owner.present?
        @workable_items.where(:owner => owner.id)
      else
        nil
      end
    end
  end

  def get_items_for_label(search_term)
    if search_term.present?
      @workable_items.select { |wi| wi.labels.map(&:name).include?(search_term) }
    else
      nil
    end
  end

  def get_items_for(search_term)
    #If I remove the workable_items. form the below query, I start getting the PG error saying the the description column is ambiguous.
    #That is because the tasks table which is also getting LEFT joined here has a description column too
    @workable_items.where("workable_items.title LIKE ? or workable_items.description LIKE ?", "%#{search_term}%", "%#{search_term}%")
  end

  def get_items_for_comments(search_term)
    if search_term.present?
      #This is to optimize the query a bit
      comments_matching_search_term = Comment.where("workable_item_id IN (?) and comment LIKE ?", @workable_items.map(&:id), "%#{search_term}%").select(:workable_item_id)
      ids = comments_matching_search_term.map(&:workable_item_id).uniq
      if ids.count > 0
        WorkableItem.where("id IN (?)", ids)
      else
        nil
      end
    else
      nil
    end
  end

  def get_items_for_tasks(search_term)
    if search_term.present?
      #This is to optimize the query a bit
      tasks_matching_search_term = Task.where("workable_item_id IN (?) and description LIKE ?", @workable_items.map(&:id), "%#{search_term}%").select(:workable_item_id)
      ids = tasks_matching_search_term.map(&:workable_item_id).uniq
      if ids.count > 0
#        raise ids.inspect
        WorkableItem.where("id IN (?)", ids)
      else
        nil
      end
    else
      nil
    end
  end

end
