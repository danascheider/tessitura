# Create Task
# ===========
When(/^the client submits a POST request to (.*) with the (\d+)(?:[a-z]{2}) user\'s credentials and:$/) do |path, id, string|
  @user = User.find(id)
  @user_task_count = @user.tasks.count
  authorize @user.username, @user.password
  make_request('POST', path, string)
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
