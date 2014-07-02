def get_changed(task_variable = @task)
  Task.find(task_variable.id)
end

def json_task(id_or_all)
  id_or_all == :all ? Task.all.to_json : Task.find(id_or_all).to_json
end

def response_status
  last_response.status
end

def response_body
  last_response.body
end

def make_request(method, path, string=nil)
  case method
  when 'POST'
    post path, string, 'CONTENT-TYPE' => 'application/json'
  when 'PUT'
    put path, string, 'CONTENT-TYPE' => 'application/json'
  when 'GET'
    get path
  when 'DELETE'
    delete path 
  end
end