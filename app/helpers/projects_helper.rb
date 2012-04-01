module ProjectsHelper

  def link_to_add_task_fields(name, f, association, item_id)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render("stories/"+association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function(name, ("add_task_fields(this, '#{association.to_s.singularize}', '#{escape_javascript(fields)}')"), :id => "#{item_id}_add_task")
  end

  def link_to_add_comment_fields(name, f, association, item_id)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render("stories/"+association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function(name, ("add_comment_fields(this, '#{association.to_s.singularize}', '#{escape_javascript(fields)}')"), :id => "#{item_id}_add_comment")
  end

  def velocity_chart_series(project, start_time)
    stories = nil
    if !project.estimate_bugs? and !project.estimate_chores?
      stories = project.stories.where(" status in ('delivered', 'accepted')")
    elsif project.estimate_bugs?
      stories = project.stories.where(" status in ('delivered', 'accepted') and type != 'Chore'")
    elsif project.estimate_chores?
      stories = project.stories.where(" status in ('delivered', 'accepted') and type != 'Bug'")
    end
    if stories
      stories_by_day = stories.where(:delivered_at => start_time.beginning_of_day..Time.zone.now.end_of_day).
          group("delivered_at, priority").
          select("priority, delivered_at, sum(estimate) as estimate")
      (start_time.to_date..Date.today).map do |date|
        story = stories_by_day.detect { |story| story.delivered_at.to_date == date }
        story && story.estimate || 0
      end.inspect
    end
  end

  def actual_burndown_chart_data_series(project)
    stories = nil
    if !project.estimate_bugs? and !project.estimate_chores?
      stories = project.stories.where(" status in ('delivered', 'accepted') and category = 'current'")
    elsif project.estimate_bugs?
      stories = project.stories.where(" status in ('delivered', 'accepted') and category = 'current' and type != 'Chore'")
    elsif project.estimate_chores?
      stories = project.stories.where(" status in ('delivered', 'accepted') and category = 'current' and type != 'Bug'")
    end
    start_time = project.current_sprint_start_date
    if stories
      stories_by_day = stories.where(:delivered_at => start_time.beginning_of_day..Date.today.end_of_day).
          group("delivered_at, priority").
          select("delivered_at as date, sum(estimate) as estimate")

      stories_by_day.concat stories.where(:accepted_at => start_time.beginning_of_day..Date.today.end_of_day).
          group("accepted_at, priority").
          select("accepted_at as date, sum(estimate) as estimate")

      sprint_commitment = project.sprint_commitment
      (start_time..Date.today).map do |date|
        story = stories_by_day.detect { |story| story.date.to_date == date }
        sprint_commitment = sprint_commitment - (story && story.estimate || 0)
      end.inspect
    end
  end

  def idle_burndown_chart_data_series(project)
    start_time = project.current_sprint_start_date
    end_time = project.current_sprint_end_date
    sprint_commitment = project.sprint_commitment
    points_to_burn_per_day = sprint_commitment.to_f / (project.days_in_sprint)
    (start_time..end_time).map do |day|
      sprint_commitment - (points_to_burn_per_day * (day - start_time).to_i)
    end.inspect
  end

end
