module Sinatra
  module Canto
    module Routing
      module TaskRoutes

        def self.registered(app)
          Canto::Routing::TaskRoutes.post_routes(app)
          Canto::Routing::TaskRoutes.put_routes(app)
          Canto::Routing::TaskRoutes.get_routes(app)
        end

        def self.get_routes(app)
          app.get '/users/:id/tasks' do |id|
            return_json(@resource.tasks.where_not(:status, 'Complete')) || [].to_json
          end

          app.get '/users/:id/tasks/all' do |id|
            return_json(@resource.tasks)
          end
        end

        def self.post_routes(app)
          app.post '/users/:id/tasks' do |id|
            (body = request_body)[:task_list_id] ||= User[id].default_task_list.id
            return 422 unless new_task = Task.try_rescue(:create, body)

            [201, new_task.to_json]
          end
        end

        def self.put_routes(app) 
          app.put '/users/:id/tasks' do |id|
            tasks = (body = request_body).map {|h| Task[h.delete(:id)] } 

            body.each do |hash| 
              (task = tasks[body.index(hash)]).set(sanitize_attributes(hash))
              return 422 unless task.valid? && task.owner_id === id.to_i
            end
            
            tasks.each {|task| task.save } && 200
          end
        end

      end
    end
  end
end