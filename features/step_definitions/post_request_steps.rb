# Create Task
# ===========
When(/^the client submits a POST request to \/users\/(\d+)\/tasks with the (\d+)(?:[a-z]{2}) user\'s credentials and:$/) do |id1, id2, string|
  @user, @current, @user_task_count = User[id1], User[id2], User[id1].tasks.count
  authorize_with @current
  make_request('POST', "/users/#{id1}/tasks", string)
end

When(/^the client submits a POST request to \/users\/(\d+)\/tasks with no credentials and:$/) do |id, string|
  @user = User[id]
  @user_task_count = @user.tasks.count if @user
  make_request('POST', "/users/#{id}/tasks", string)
end

# Create User
# ===========
When(/^the client submits a POST request to \/users with:$/) do |string|
  @user_count = User.count
  make_request('POST', '/users', string)
end

# Create Admin User
# =================
When(/^the client submits a POST request to \/admin\/users with the (\d+)(?:[a-z]{2}) user's credentials and:$/) do |id, string|
  authorize_with (@current = User[id])
  make_request('POST', '/admin/users', string)
end

When(/^the client submits a POST request to \/admin\/users with no credentials and:$/) do |string|
  make_request('POST', '/admin/users', string)
end
