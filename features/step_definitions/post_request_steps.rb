# Create Task
# ===========
When(/^the client submits a POST request to \/users\/(\d+)\/tasks with the (\d+)(?:[a-z]{2}) user\'s credentials and:$/) do |id1, id2, string|
  @user = get_resource(User, id1)
  @current = get_resource(User, id2)
  @user_task_count = @user.tasks.count
  authorize @current.username, @current.password
  make_request('POST', "/users/#{id1}/tasks", string)
end

When(/^the client submits a POST request to \/users\/(\d+)\/tasks with no credentials and:$/) do |id, string|
  @user = get_resource(User, id)
  @user_task_count = @user.tasks.count if @user
  make_request('POST', "/users/#{id}/tasks", string)
end

# Create User
# ===========
When(/^the client submits a POST request to \/users with the (\d+)(?:[a-z]{2}) user's credentials and:$/) do |id, string|
  @current = get_resource(User, id)
  authorize @current.username, @current.password
  make_request('POST', '/users', string)
end


When(/^the client submits a POST request to \/users with:$/) do |string|
  make_request('POST', '/users', string)
end

# Create Admin User
# =================
When(/^the client submits a POST request to \/admin\/users with the (\d+)(?:[a-z]{2}) user's credentials and:$/) do |id, string|
  @current = get_resource(User, id)
  authorize @current.username, @current.password 
  make_request('POST', '/admin/users', string)
end

When(/^the client submits a POST request to \/admin\/users with no credentials and:$/) do |string|
  make_request('POST', '/admin/users', string)
end