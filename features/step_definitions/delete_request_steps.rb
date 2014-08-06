# Delete User
# ===========
When(/^the client submits a DELETE request to \/users\/(\d+) with the (\d+)(?:[a-z]{2}) user\'s credentials$/) do |path, id|
  @user = get_resource(User, id)
  @user_count = User.count
  authorize @user.username, @user.password
  make_request('DELETE', "/users/#{path}")
end

# Delete Task
# ===========
When(/^the client submits a DELETE request to \/tasks\/(\d+) with the (\d+)(?:[a-z]{2}) user's credentials$/) do |task_id, user_id|
  @task = get_resource(Task, task_id)
  @current = get_resource(User, user_id)
  authorize @current.username, @current.password
  make_request('DELETE', "/tasks/#{task_id}")
end

# Unauthorized
# ============
When(/^the client submits a DELETE request to (.*) with no credentials$/) do |id|
  make_request('DELETE', "/users/#{id}")
end