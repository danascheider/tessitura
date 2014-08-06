# View Task List
# ==============
When(/^the client submits a GET request to \/users\/(\d+)\/tasks with the (\d+)(?:[a-z]{2}) user's credentials$/) do |id1, id2|
  @user = get_resource(User, id1)
  @current = get_resource(User, id2)
  authorize @current.username, @current.password  
  make_request('GET', "/users/#{id1}/tasks")
end

# View Task(s)
# ============
When(/^the client submits a GET request to \/tasks\/(\d+) with the (\d+)(?:[a-z]{2}) user's credentials$/) do |task_id, user_id|
  @task = get_resource(Task, task_id)
  @current  = get_resource(User, user_id)
  authorize @current.username, @current.password
  make_request('GET', "/tasks/#{task_id}")
end

# View All Users
# ==============
When(/^the client submits a GET request to \/admin\/users with admin credentials$/) do
  @admin = User.admin.first 
  authorize @admin.username, @admin.password
  make_request('GET', '/admin/users')
end

# General
# =======
When(/^the client submits a GET request to (.*) with no credentials$/) do |path|
  make_request('GET', path)
end