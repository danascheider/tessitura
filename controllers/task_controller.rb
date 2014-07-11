class Sinatra::Application

  module TaskController

    # The begin_and_rescue method is defined in the ErrorHandling module.

    # BASIC CONTROLLER METHODS
    # ========================

    def create_task(body)
      Task.create!(body)
    end

    def get_task(id)
      Task.find(id).to_json
    end

    def update_task(id, body)
      Task.find(id).update!(body)
    end

    def delete_task(id)
      Task.find(id).destroy 
    end
  end

  helpers TaskController
end