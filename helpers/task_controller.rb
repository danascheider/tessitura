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
        update_indices(body)
        @task.update!(body)
      end
    end

    def delete_task(id)
      begin_and_rescue(ActiveRecord::RecordNotFound, 404) { find_task(id).destroy && 204 }
    end

    # HELPER METHODS
    # ==============

    def update_indices(object)
      return true unless change_index? object
      other_tasks.each do |task|
        task.update!(index: index(task) - 1) if (task.index <= object[:index].to_i)
      end
    end

    protected
      def change_index?(object)
        (object.has_key? :index) && (object[:index] != @task.index)
      end

      def other_tasks
        Task.where.not(id: @task.id)
      end

      def index(task)
        task.index
      end
  end

  helpers TaskController
end