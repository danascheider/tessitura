module TasksHelper
  def task_form(task, opts = {})
    @task   = task
    @action = opts[:action]

    case opts[:action]
      when :create
        @destination  = tasks_path
        @button_value = 'Create Task'

      when :update
        @destination  = task_path(@task)
        @button_value = 'Update Task'

      else
        raise ArgumentError, 'task_form() can only handle :create and :update actions'
    end

    render 'shared/task_form'
  end
end
