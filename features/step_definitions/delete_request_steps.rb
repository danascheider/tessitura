# Delete User
# ===========
When(/^the client submits a DELETE request to \/users\/(\d+) with the (\d+)(?:[a-z]{2}) user\'s credentials$/) do |path, id|
  @user = User[id]
  authorize_with @user
  make_request('DELETE', "/users/#{path}")
end

# Delete Task
# ===========
When(/^the client submits a DELETE request to \/tasks\/(\d+) with the (\d+)(?:[a-z]{2}) user's credentials$/) do |task_id, user_id|
  @task, @current = Task[task_id], User[user_id]
  authorize_with @current
  make_request('DELETE', "/tasks/#{task_id}")
end

# Unauthorized
# ============
When(/^the client submits a DELETE request to (.*) with no credentials$/) do |id|
  make_request('DELETE', "/users/#{id}")
end