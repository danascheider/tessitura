class Sinatra::Application

  module TaskController

    # The begin_and_rescue method is defined in the ErrorHandling module.

    # BASIC CONTROLLER METHODS
    # ========================

    def create_task(body)
      begin_and_rescue(ActiveRecord::RecordInvalid, 422) { Task.create!(body) && 201 }
    end

    def get_task(id)
      begin_and_rescue(ActiveRecord::RecordNotFound, 404) { find_task(id).to_json }
    end

    def update_task(id, body)
      begin_and_rescue(ActiveRecord::RecordInvalid, 422) do 
        @task = find_task(id)

        # Check if index needs to be changed
        if (body.has_key? :index) && (body[:index] != @task.index)
          update_indices(body)
        end

        if (body.has_key? :complete) && (body[:complete] != @task.complete)
          body[:index] = Task.max_index
        end

        @task.update!(body)
      end
    end

    def delete_task(id)
      begin_and_rescue(ActiveRecord::RecordNotFound, 404) { find_task(id).destroy && 204 }
    end

    # HELPER METHODS
    # ==============
    
    def changed_index?(object)
      (object.has_key? :index) && !compare_index(@task, object)
    end

    def compare_index(task,object)
      task.index == object[:index]
    end

    def index(task)
      task.index
    end

    protected

      def other_tasks
        Task.where.not(id: @task.id)
      end

      def update_indices(object)
        return true unless changed_index? object
        other_tasks.each do |task|
          task.update!(index: index(task) - 1) if (task.index <= object[:index].to_i)
        end
      end
  end

  helpers TaskController
end