module ApplicationHelper
  def mark_complete_button(task = nil)
    
    raise ArgumentError unless (@task || task)

    @task ||= task
    form_for @task, url: mark_complete_task_url(Task.find(@task.id)) do |f|
      f.button '', name: 'task[complete]',
                   value: '1',
                   class: 'fa fa-check btn btn-info btn-circle mark-complete',
                   method: :patch,
                   "data-remote" => true
    end
  end
end
