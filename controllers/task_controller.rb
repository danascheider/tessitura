class Sinatra::Application

  module TaskController

    # The begin_and_rescue method is defined in the ErrorHandling module.

    # BASIC CONTROLLER METHODS
    # ========================

    def create_task(body)
      begin_and_rescue(ActiveRecord::RecordInvalid, 422) do 
        body[:index] = body[:index] ? validate_index(body[:index], :create) : assign_default_index(body)
        Task.update_indices(body[:index], Task.max_index)
        @task = Task.create!(body) && 201
      end
    end

    def get_task(id)
      begin_and_rescue(ActiveRecord::RecordNotFound, 404) { find_task(id).to_json }
    end

    def update_task(id, body)
      begin_and_rescue(ActiveRecord::RecordInvalid, 422) do 
        @task = find_task(id)

        if changed_completion_status?(@task, body) then body[:index] ||= Task.max_index; end

        if changed_index?(@task, body)
          body[:index] = validate_index(body[:index])
          old, n3w = @task.index.to_i, body[:index].to_i
          old > n3w ? (Task.update_indices(n3w, old - 1)) : (Task.update_indices(old + 1, n3w, -1))
        end

        @task.update!(body)
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
    def changed_completion_status?(task, object)
      (object.has_key? :complete) && (object[:complete] != task.complete)
    end

    def changed_index?(task, object)
      (object.has_key? :index) && !equal_index?(task, object)
    end

    def equal_index?(task,object)
      task.index == object[:index]
    end

    def index(task)
      task.index
    end

    def index_in?(task, val1, val2)
      val1, val2 = val1.to_i, val2.to_i
      val1 <= val2 ? task.index.between?(val1, val2) : task.index.between?(val2, val1)
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