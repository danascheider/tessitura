class Sinatra::Application
  module TaskManager
    def update_indices(index)
      Task.all.each do |task|
        if task.index <= index then task.index += 1 && task.save; end
      end
    end
  end

  helpers TaskManager
end