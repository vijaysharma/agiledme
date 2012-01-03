module ProjectsHelper
  def add_task_link(name, form)
    link_to_function name do |page|
      task = render(:partial => 'workable_items/new_task', :locals => {:project_form => form, :task => Task.new})
      page << %{
      alert($(this).attr('name'));
      alert($(this).attr('id'));
      alert($(this).attr('class'));
    $("#{ escape_javascript task }").appendTo('#tasks');
  }
    end
  end

  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render("workable_items/"+association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function(name, ("add_fields(this, '#{association}', '#{escape_javascript(fields)}')"))
  end

end
