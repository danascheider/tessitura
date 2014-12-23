# Create Task
# ===========
When(/^the client submits a POST request to \/users\/(\d+)\/tasks with the (\d+)(?:[a-z]{2}) user\'s credentials and:$/) do |id1, id2, string|
  @user, @current = User[id1], User[id2]
  @user_task_count = @user.tasks.count
  authorize_with @current
  post "/users/#{id1}/tasks", string, 'CONTENT_TYPE' => 'application/json'
end

When(/^the client submits a POST request to \/users\/(\d+)\/tasks with no credentials and:$/) do |id, string|
  @user = User[id]
  @user_task_count = @user.tasks.count if @user
  post "/users/#{id}/tasks", string, 'CONTENT_TYPE' => 'application/json'
end

# Create User
# ===========
When(/^the client submits a POST request to \/users with:$/) do |string|
  @user_count = User.count
  post '/users', string, 'CONTENT_TYPE' => 'application/json'
end

When(/^the client submits a POST request to \/users with the (\d+)(?:[a-z]{2}) user's credentials and:$/) do |id, string|
  authorize_with (@current = User[id])
  post '/users', string, 'CONTENT_TYPE' => 'application/json'
end

# Create Admin User
# =================
When(/^the client submits a POST request to \/admin\/users with the (\d+)(?:[a-z]{2}) user's credentials and:$/) do |id, string|
  authorize_with (@current = User[id])
  post '/admin/users', string, 'CONTENT_TYPE' => 'application/json'
end

When(/^the client submits a POST request to \/admin\/users with no credentials and:$/) do |string|
  post '/admin/users', string, 'CONTENT_TYPE' => 'application/json'
end

# Create Organization
# ===================
When(/^the client submits a POST request to \/organizations with admin credentials and:$/) do |string|
  @count = Organization.count
  authorize_with(User[1])
  post '/organizations', string, 'CONTENT_TYPE' => 'application/json'
end

When(/^the client submits a POST request to \/organizations with no credentials and:$/) do |string|
  @count = Organization.count 
  post 'organizations', string, 'CONTENT_TYPE' => 'application/json'
end

When(/^the client submits a POST request to \/organizations with the (\d+)(?:[a-z]{2}) user's credentials and:$/) do |uid, string|
  @count = Organization.count
  authorize_with(User[uid])
  post '/organizations', string, 'CONTENT_TYPE' => 'application/json'
end

# Create Program
# ==============

When(/^the client submits a POST request to \/organizations\/(\d+)\/programs with (.*) credentials and:$/) do |id, type, string|
  @count= Program.count
  authorize_with User[type === 'admin' ? 1 : 2]
  post "/organizations/#{id}/programs", string, 'CONTENT_TYPE' => 'application/json'
end