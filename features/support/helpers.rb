def get_changed
  Task.find(@task.id)
end

def make_request(method, path, string=nil)
  options = yield if block_given?
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