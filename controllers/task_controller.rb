class Sinatra::Application

  module TaskController

    # The begin_and_rescue method is defined in the ErrorHandling module.

    # BASIC CONTROLLER METHODS
    # ========================

    def create_task(body)
      begin_and_rescue(ActiveRecord::RecordInvalid, 422) do 
        if body.has_key? :index 
          update_on_specified_create(body[:index])
        else 
          update_on_default_create
        end
        @task = Task.create!(body) && 201
      end
    end

    def get_task(id)
      begin_and_rescue(ActiveRecord::RecordNotFound, 404) { find_task(id).to_json }
    end

    def update_task(id, body)
      begin_and_rescue(ActiveRecord::RecordInvalid, 422) do 
        @task = find_task(id)

        # Check if index needs to be changed
        if changed_completion_status?(@task, body)
          body[:index] = Task.max_index
        end

        if changed_index?(@task, body)
          update_indices(body)
        end

        @task.update!(body)
      end
    end

    def delete_task(id)
      begin_and_rescue(ActiveRecord::RecordNotFound, 404) { find_task(id).destroy && 204 }
    end

    # HELPER METHODS
    # ==============
    def changed_completion_status?(task, object)
      (object.has_key? :complete) && (object[:complete] != task.complete)
    end

    def changed_index?(task, object)
      (object.has_key? :index) && !compare_index(task, object)
    end

    def compare_index(task,object)
      task.index == object[:index]
    end

    def decrement_index(task)
      task.update!(index: task.index - 1)
    end

    def index(task)
      task.index
    end

    def increment_index(task)
      task.update!(index: task.index + 1)
    end

    def index_in?(task, val1, val2)
      val1, val2 = val1.to_i, val2.to_i
      val1 <= val2 ? task.index.between?(val1, val2) : task.index.between?(val2, val1)
    end

    protected

      def other_tasks
        Task.where.not(id: @task.id)
      end

      def update_on_default_create
        Task.all.each {|task| increment_index(task) }
      end

      def update_on_specified_create(index)
        Task.where("index > ?", index).each {|task| increment_index(task)}
      end

      def update_indices(object)
        other_tasks.each do |task|
          decrement_index(task) if index_in?(task, index(@task), object[:index])
        end
      end
  end

  register TaskController
end