def authorize_with(user)
  authorize user.username, user.password
end

def decode_form_data(data)
  form_data = URI::decode_www_form(data).flatten
  hash = Hash[*form_data]
  hash
end

# Debugging method for tasks
def dump_tasks
  puts "TASKS:"
  Task.all.each {|task| puts "#{task.to_hash}\n"}
end

# Debugging method for users
def dump_users
  puts "USERS:"
  User.all.each do |user|
    hash = user.to_hash
    hash[:username] = user.username
    hash[:password] = user.password
    puts "#{hash}\n"
  end
end

def dump_user_tasks(id)
  puts "USER #{id}'S TASKS:"
  User[id].tasks.flatten.each {|task| puts "#{task.to_hash}\n"}
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
    post path, string, 'CONTENT-TYPE' => 'application/x-www-form-urlencoded'
  when 'PUT'
    put path, string, 'CONTENT-TYPE' => 'application/json'
  when 'GET'
    get path
  when 'DELETE'
    delete path 
  end
end