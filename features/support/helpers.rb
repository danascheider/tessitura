def make_request(method, path, &block)
  contents = yield if block_given?
  case method
  when 'POST'
    post path, contents
  when 'PUT'
    put path, contents
  when 'GET'
    get path
  when 'DELETE'
    delete path 
  end
end