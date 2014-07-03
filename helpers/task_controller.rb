class Sinatra::Application

  module TaskController

    def create_task(body)
      begin_and_rescue(ActiveRecord::RecordInvalid, 422) { Task.create!(body) && 201 }
    end

    def update_indices(index)
      Task.all.each do |task|
        if task.index <= index then task.index -= 1 && task.save!; end
      end
    end

  end

  helpers TaskController
end