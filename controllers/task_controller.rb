class Sinatra::Application

  module TaskController
    include TaskIndexing

    # The begin_and_rescue method is defined in the ErrorHandling module.

    # BASIC CONTROLLER METHODS
    # ========================

    def create_task(body)
      begin_and_rescue(ActiveRecord::RecordInvalid, 422) do 
        body[:index] = body[:index] ? validate_index(body[:index], :create) : assign_default_index(body)
        @task = Task.create!(body) && update_indices && 201
      end
    end

    def get_task(id)
      begin_and_rescue(ActiveRecord::RecordNotFound, 404) { find_task(id).to_json }
    end

    def update_task(id, body)
      begin_and_rescue(ActiveRecord::RecordInvalid, 422) do 
        @task = find_task(id)
        body[:index] ||= index_on_completion_status(@task, body)
        @task.update!(body) && update_indices
      end
    end

    def delete_task(id)
      begin_and_rescue(ActiveRecord::RecordNotFound, 404) do  
        index = (@task = find_task(id)).index 
        Task.update_indices(index, Task.max_index, -1)
        @task.destroy && 204
      end
    end

    # HELPER METHODS
    # ==============
    def index_on_completion_status(task, object)
      if (object.has_key? :complete) && (object[:complete] != task.complete)
        object[:complete] == true ? Task.max_index : 1
      end
    end

    def changed_index?(task, object)
      object[:index] && object[:index] != task.index
    end
    
    protected
      def assign_default_index(object)
        object[:complete] ? Task.complete.pluck(:index).sort[0] : 1
      end

      def validate_index(index, method=:update)
        max = method == :create ? (Task.max_index + 1) : Task.max_index
        if index < 1 then 1; elsif index > max then max; else index; end
      end
  end

  helpers TaskController
end