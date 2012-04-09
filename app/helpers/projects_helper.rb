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

end
