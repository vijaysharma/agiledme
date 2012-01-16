module ProjectsHelper

  def link_to_add_task_fields(name, f, association, item_id)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render("workable_items/"+association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function(name, ("add_task_fields(this, '#{association.to_s.singularize}', '#{escape_javascript(fields)}')"), :id => "#{item_id}_add_task")
  end

  def link_to_add_comment_fields(name, f, association, item_id)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render("workable_items/"+association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function(name, ("add_comment_fields(this, '#{association.to_s.singularize}', '#{escape_javascript(fields)}')"), :id => "#{item_id}_add_comment")
  end

  def velocity_chart_series(project, start_time)

    if !project.estimate_bugs? and !project.estimate_chores?
     workable_items = project.workable_items.where(" status = 'delivered'")
    elsif project.estimate_bugs?
      workable_items = project.workable_items.where(" status = 'delivered' and type != 'Chore'")
    elsif project.estimate_chores?
      workable_items = project.workable_items.where(" status = 'delivered' and type != 'Bug'")
    end

    workable_items_by_day = workable_items.where(:delivered_at => start_time.beginning_of_day..Time.zone.now.end_of_day).
                    group("date(delivered_at)").
                    select("delivered_at, sum(estimate) as estimate")
    (start_time.to_date..Date.today).map do |date|
      workable_item = workable_items_by_day.detect { |workable_item| workable_item.delivered_at.to_date == date }
      workable_item && workable_item.estimate || 0
    end.inspect
  end

end
