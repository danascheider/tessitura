# Create Task
# ===========
When(/^the client submits a POST request to \/users\/(\d+)\/tasks with the (\d+)(?:[a-z]{2}) user\'s credentials and:$/) do |id1, id2, string|
  data = URI::encode_www_form(JSON.parse(string))
  @user, @current, @user_task_count = User[id1], User[id2], User[id1].tasks.count
  authorize_with @current
  make_request('POST', "/users/#{id1}/tasks", data)
end

When(/^the client submits a POST request to \/users\/(\d+)\/tasks with no credentials and:$/) do |id, string|
  data = URI::encode_www_form(JSON.parse(string))
  @user = User[id]
  @user_task_count = @user.tasks.count if @user
  make_request('POST', "/users/#{id}/tasks", data)
end

# Create User
# ===========
When(/^the client submits a POST request to \/users with:$/) do |string|
  data = URI::encode_www_form(JSON.parse(string))
  @user_count = User.count
  make_request('POST', '/users', data)
end

When(/^the client submits a POST request to \/users with the (\d+)(?:[a-z]{2}) user's credentials and:$/) do |id, string|
  data = URI::encode_www_form(JSON.parse(string))
  authorize_with (@current = User[id])
  make_request('POST', '/users', data)
end

# Create Admin User
# =================
When(/^the client submits a POST request to \/admin\/users with the (\d+)(?:[a-z]{2}) user's credentials and:$/) do |id, string|
  data = URI::encode_www_form(JSON.parse(string))
  authorize_with (@current = User[id])
  make_request('POST', '/admin/users', data)
end

When(/^the client submits a POST request to \/admin\/users with no credentials and:$/) do |string|
  data = URI::encode_www_form(JSON.parse(string))
  make_request('POST', '/admin/users', string)
end
