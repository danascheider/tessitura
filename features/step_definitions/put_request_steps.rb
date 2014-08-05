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
When(/^the client submits a PUT request to that task URL with the (\d+)(?:[a-z]{2}) user's credentials and:$/) do |id, string|
  @user = get_resource(User, id)
  authorize @user.username, @user.password
  make_request('PUT', "/tasks/#{@task.id}", string)
end

When(/^the client submits a PUT request to the (first|last) task URL with the (\d+)(?:[a-z]{2}) user's credentials and:$/) do |order, id, string|
  @task = order == 'first' ? Task.first : Task.last
  @user = get_resource(User, id)
  authorize @user.username, @user.password
  make_request('PUT', "/tasks/#{@task.id}", string)
end

When(/^the client submits a PUT request to \/tasks\/(\d+) with admin credentials and:$/) do |id, string|
  @admin = User.admin.first
  authorize @admin.username, @admin.password
  make_request('PUT', "/tasks/#{id}", string)
end

When(/^the client submits a PUT request to the last task URL with no credentials and:$/) do |string|
  @task = Task.last
  make_request('PUT', "/tasks/#{@task.id}", string)
end