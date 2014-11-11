def decode_form_data(data)
  form_data = URI::decode_www_form(data).flatten
  hash = Hash[*form_data]
  hash
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
  User[id].tasks.flatten.each {|task| puts "#{task.to_hash}\n"}
end