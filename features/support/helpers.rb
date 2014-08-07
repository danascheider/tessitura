def authorize_and_make_request(auth, opts)
  authorize_with auth if auth
  make_request(opts[:method], opts[:path], opts[:body])
end

def authorize_with(user)
  authorize user.username, user.password
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
  User.find(id).tasks.each {|task| puts "#{task.to_hash}\n"}
end

def get_changed_task
  Task.find(@task.id)
end

def get_changed_user
  User.find(@user.id)
end

def get_resource(klass, id, &block) 
  begin 
    if block_given? then yield klass.find(id); else klass.find(id); end
  rescue
    nil
  end
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