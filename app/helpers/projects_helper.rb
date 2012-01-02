module ProjectsHelper
  def add_task_link(name, form)
    link_to_function name do |page|
      task = render(:partial => 'workable_items/new_task', :locals => {:project_form => form, :task => Task.new})
      page << %{
    alert($('#latest_task_description').val());
    $("#{ escape_javascript task }").appendTo('#tasks');
    alert($('#new_task_description_label').val());
  }
    end
  end
end
