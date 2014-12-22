# View Task List
# ==============
When(/^the client submits a GET request to \/users\/(\d+)\/tasks with the (\d+)(?:[a-z]{2}) user's credentials$/) do |id1, id2|
  @user, @current = User[id1], User[id2]
  authorize_with @current 
  get "/users/#{id1}/tasks"
end

When(/^the client submits a GET request to \/users\/(\d+)\/tasks\/all with the (\d+)(?:[a-z]{2}) user's credentials$/) do |id1, id2|
  @user, @current = User[id1], User[id2]
  authorize_with @current 
  get "/users/#{id1}/tasks/all"
end

# View Task(s)
# ============
When(/^the client submits a GET request to \/tasks\/(\d+) with the (\d+)(?:[a-z]{2}) user's credentials$/) do |task_id, user_id|
  @task, @current = Task[task_id], User[user_id]
  authorize_with @current
  get "/tasks/#{task_id}"
end

# View User Profile
# =================
When(/^the client submits a GET request to \/users\/(\d+) with the (\d+)(?:[a-z]{2}) user's credentials$/) do |req_id, actual_id|
  @user, @current = User[req_id], User[actual_id]
  authorize_with @current
  get "/users/#{req_id}"
end

# View All Users
# ==============
When(/^the client submits a GET request to \/admin\/users with the (\d+)(?:[a-z]{2}) user's credentials$/) do |id|
  @current = User[id]
  authorize_with @current
  get '/admin/users'
end

When(/^the client submits a GET request to its individual endpoint with (.*) credentials$/) do |type|
  authorize_with User[type === 'admin' ? 1 : 2] unless type === 'no'
  get "/organizations/#{@organization.id}"
end

# Unauthorized
# ============
When(/^the client submits a GET request to (.*) with no credentials$/) do |path|
  get path
end

When(/^the client submits a GET request to \/users with the (\d+)(?:[a-z]{2}) user's credentials$/) do |id|
  @current = User[id]
  authorize_with @current
  get '/users'
end