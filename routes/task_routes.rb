module Sinatra
  module Canto
    module Routing
      module TaskRoutes

        def self.registered(app)
          TaskRoutes.post_routes(app)
          TaskRoutes.put_routes(app)
          TaskRoutes.get_routes(app)

          app.delete '/tasks/:id' do |id|
            Routing.delete(Task, id)
          end

        end

        def self.get_routes(app)
          app.get '/users/:id/tasks' do |id|
            return_json(User[id].tasks.where_not(:status, 'Complete')) || [].to_json
          end

          app.get '/users/:id/tasks/all' do |id|
            return_json(User[id].tasks)
          end

          app.get '/tasks/:id' do |id|
            Routing.get_single(Task, id)
          end
        end

        def self.post_routes(app)
          app.post '/users/:id/tasks' do |id|
            (body = request_body)[:task_list_id] ||= User[id].default_task_list.id
            Routing.post(Task, body)
          end
        end

        def self.put_routes(app) 
          app.put '/users/:id/tasks' do |id|
            tasks = (body = request_body).map {|h| Task[h.delete(:id)] } 
            Routing.bulk_update(tasks, body, id) && 200 rescue 422
          end

          app.put '/tasks/:id' do |id|
            update_resource(request_body, Task[id])
          end
        end

      end
    end
  end
end