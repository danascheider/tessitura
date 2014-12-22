# Delete User
# ===========
When(/^the client submits a DELETE request to \/users\/(\d+) with the (\d+)(?:[a-z]{2}) user\'s credentials$/) do |path, id|
  @user = User[id]
  authorize_with @user
  delete "/users/#{path}"
end

# Delete Task
# ===========
When(/^the client submits a DELETE request to \/tasks\/(\d+) with the (\d+)(?:[a-z]{2}) user's credentials$/) do |task_id, user_id|
  @task, @current = Task[task_id], User[user_id]
  authorize_with @current
  delete "/tasks/#{task_id}"
end

# Delete Organization
# ===================

When(/^the client submits a DELETE request to \/organizations\/(\d+) with (admin|user) credentials$/) do |id, type|
  @organization = Organization[id]
  authorize_with User[type === 'admin' ? 1 : 2]
  delete "/organizations/#{id}"
end

# Unauthorized
# ============
When(/^the client submits a DELETE request to (.*) with no credentials$/) do |path|
  delete path
end