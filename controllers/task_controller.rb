class Sinatra::Application

  module TaskController

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