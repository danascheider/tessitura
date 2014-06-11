module ApplicationHelper
  def mark_complete_button(task)
    form_for task, url: mark_complete_url(task) do |f|
      f.button '', name: 'task[complete]',
                   value: '1',
                   class: 'fa fa-check btn btn-info btn-circle mark-complete',
                   method: :patch,
                   "data-remote" => true
    end
  end
end
