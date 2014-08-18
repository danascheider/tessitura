class Sinatra::Application
  module FilterHelper

    def filter_resources(hash)
      tasks = TaskFilter.new(hash[:filters], hash[:user]).filter.to_a.map {|task| task.to_hash } 
      tasks.to_json
    end
  end

  helpers FilterHelper
end