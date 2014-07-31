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

def find_task(id)
  Task.find(id)
end

def find_user(id)
  User.find(id)
end

def find_user_by_key(key)
  User.find_by(secret_key: key)
end

def json_task(id_or_all)
  id_or_all == :all ? Task.all.to_json : Task.find(id_or_all).to_json
end

def json_user(id_or_all)
  id_or_all == :all ? User.all.to_json : User.find(id_or_all).to_json
end

def response_status
  last_response.status
end

def response_body
  last_response.body
end

def neg_task_scope(hash)
  Task.where.not(hash)
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