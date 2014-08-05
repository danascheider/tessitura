When(/^the client submits a PUT request to \/users\/(\d+) with admin credentials and$/) do |id, string|
  @user, @admin = get_resource(User, id), User.admin.first
  authorize @admin.username, @admin.password
  make_request('PUT', "/users/#{id}", string)
end

When(/^the client submits a PUT request to \/users\/(\d+) with the (\d+)(?:[a-z]{2}) user's credentials and:$/) do |path_id, user_id, string|
  @user, @requesting_user = User.find(path_id), User.find(user_id)
  authorize @requesting_user.username, @requesting_user.password
  make_request('PUT', "/users/#{path_id}", string)
end

When(/^the client submits a PUT request to that task URL with the (\d+)(?:[a-z]{2}) user's credentials and:$/) do |id, string|
  @user = User.find(id)
  authorize @user.username, @user.password
  make_request('PUT', "/tasks/#{@task.id}", string)
end

When(/^the client submits a GET request to \/users\/(\d+) with no credentials and:$/) do |id, string|
  make_request('GET', "/users/#{id}", string)
end

When(/^the client submits a PUT request to the (first|last) task URL with the (\d+)(?:[a-z]{2}) user's credentials and:$/) do |order, id, string|
  @task = order == 'first' ? Task.first : Task.last
  @user = User.find(id)
  authorize @user.username, @user.password
  make_request('PUT', "/tasks/#{@task.id}", string)
end

When(/^the client submits a PUT request to \/tasks\/(\d+) with admin credentials and:$/) do |id, string|
  @admin = User.admin.first
  authorize @admin.username, @admin.password
  make_request('PUT', "/tasks/#{id}", string)
end

When(/^the client submits a PUT request to \/users\/(.*) with (user|admin) credentials and:$/) do |path, type, string|
  user = type == 'admin' ? User.first : User.last
  authorize user.username, user.password
  make_request('PUT', "/users/#{path}", string)
end

When(/^the client submits a PUT request to the last task URL with no credentials and:$/) do |string|
  @task = Task.last
  make_request('PUT', "/tasks/#{@task.id}", string)
end