# Updating Users
# ==============
When(/^the client submits a PUT request to \/users\/(\d+) with no credentials and:$/) do |id, string|
  @user = User[id]
  make_request('PUT', "/users/#{id}", string)
end

When(/^the client submits a PUT request to \/users\/(\d+) with the (\d+)(?:[a-z]{2}) user's credentials and:$/) do |path_id, user_id, string|
  @user, @current = User[path_id], User[user_id]
  authorize_with @current
  make_request('PUT', "/users/#{path_id}", string)
end

# Updating Tasks
# ==============
When(/^the client submits a PUT request to \/tasks\/(\d+) with the (\d+)(?:[a-z]{2}) user's credentials and:$/) do |task_id, uid, string|
  @task = Task[task_id]
  @current = User[uid]
  authorize_with @current
  make_request('PUT', "/tasks/#{task_id}", string)
end

When(/^the client submits a PUT request to \/tasks\/(\d+) with no credentials and:$/) do |id, string|
  @task = Task[id]
  make_request('PUT', "/tasks/#{id}", string)
end
