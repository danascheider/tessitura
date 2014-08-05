# Create Task
# ===========
When(/^the client submits a POST request to \/users\/(\d+)\/tasks with the (\d+)(?:[a-z]{2}) user\'s credentials and:$/) do |id1, id2, string|
  @user = get_resource(User, id1)
  @current = get_resource(User, id2)
  @user_task_count = @user.tasks.count
  authorize @current.username, @current.password
  make_request('POST', "/users/#{id1}/tasks", string)
end

When(/^the client submits a POST request to (.*) with (user|admin) credentials and:$/) do |path, type, string|
  @user = type == 'admin' ? User.admin.first : User.last
  id = /(\d+)/.match(path).to_s
  @user_task_count = @user.tasks.count
  authorize @user.username, @user.password
  make_request('POST', path, string)
end

When(/^the client submits a POST request to (.*) with no credentials and:$/) do |path, string|
  id = /(\d+)/.match(path).to_s
  @user = get_resource(User, id)
  @user_task_count = @user.tasks.count
  make_request('POST', path, string)
end
