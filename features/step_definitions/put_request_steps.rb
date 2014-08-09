# Updating Users
# ==============
When(/^the client submits a PUT request to \/users\/(\d+) with no credentials and:$/) do |id, string|
  @user = get_resource(User, id)
  make_request('PUT', "/users/#{id}", string)
end

When(/^the client submits a PUT request to \/users\/(\d+) with the (\d+)(?:[a-z]{2}) user's credentials and:$/) do |path_id, user_id, string|
  @user, @current = get_resource(User, path_id), get_resource(User, user_id)
  authorize @current.username, @current.password
  make_request('PUT', "/users/#{path_id}", string)
end

# Updating Tasks
# ==============
When(/^the client submits a PUT request to \/tasks\/(\d+) with the (\d+)(?:[a-z]{2}) user's credentials and:$/) do |task_id, uid, string|
  @task = get_resource(Task, task_id)
  @current = get_resource(User, uid)
  authorize @current.username, @current.password
  make_request('PUT', "/tasks/#{task_id}", string)
end

When(/^the client submits a PUT request to \/tasks\/(\d+) with no credentials and:$/) do |id, string|
  @task = get_resource(Task, id)
  make_request('PUT', "/tasks/#{id}", string)
end
