module ProjectsHelper
  def add_task_link(name, form)
    link_to_function name do |page|
      task = render(:partial => 'workable_items/task', :locals => {:project_form => form, :task => Task.new})
      page << %{ $('"#{ escape_javascript task }"').appendTo('#tasks'); }
    end
  end
end
