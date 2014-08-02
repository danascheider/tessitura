# REQUEST STEPS
# =============

When(/^the client submits a GET request to (.*) with the (\d+)(?:[a-z]{2}) user's credentials$/) do |path, id|
  user = get_resource(User, id)
  authorize user.username, user.password
  make_request('GET', path)
end

When(/^the client submits a GET request to \/users\/(\d+)\/tasks with admin credentials$/) do |id|
  @admin, @user = User.admin.first, User.find(id)
  authorize @admin.username, @admin.password
  make_request('GET', "/users/#{id}/tasks")
end

When(/^the client submits a GET request to \/users\/(\d+)\/tasks with no credentials$/) do |id|
  make_request('GET', "/users/#{id}/tasks")
end

When(/^the client submits a GET request to \/tasks\/(\d+) with admin credentials$/) do |id|
  @admin = User.admin.first
  authorize @admin.username, @admin.password
  make_request('GET', "/tasks/#{id}")
end

When(/^the client submits a GET request to the (first|last) task URL with (owner|admin) credentials$/) do |order, user|
  @task = order == 'first' ? Task.first : Task.last
  @user = user == 'owner' ? @task.user : User.admin.first
  authorize @user.username, @user.password
  make_request('GET', "/tasks/#{@task.id}")
end

When(/^the client submits a GET request to the (first|last) task URL with (user|no) credentials$/) do |order, type|
  @task = order == 'first' ? Task.first : Task.last
  @user = type == 'user' ? User.where(admin: false).first : nil
  authorize @user.username, @user.password if @user
  make_request('GET', "/tasks/#{@task.id}")
end

When(/^the client submits a (.*) request to \/(\S+)$/) do |method, path|
  @request_time = Time.now.utc
  make_request(method, path)
end

When(/^the client submits a POST request to (.*) with (user|admin) credentials and:$/) do |path, type, string|
  @user = type == 'admin' ? User.admin.first : User.last
  id = /(\d+)/.match(path).to_s
  @user_task_count = get_resource(User, id) {|user| user.tasks.count }
  authorize @user.username, @user.password
  make_request('POST', path, string)
end

When(/^the client submits a POST request to (.*) with no credentials and:$/) do |path, string|
  id = /(\d+)/.match(path).to_s
  @user, @user_task_count = get_resource(User, id), get_resource(User, id) {|user| user.tasks.count}
  make_request('POST', path, string)
end

When(/^the client submits a PUT request to (.*) with (user|admin) credentials and:$/) do |path, type, string|
  user = type == 'admin' ? User.first : User.last
  authorize user.username, user.password
  make_request('PUT', path, string)
end

When(/^the client submits a PUT request to (.*) with no credentials and:$/) do |path, string|
  make_request('PUT', path, string)
end

When(/^the client submits a (.*) request to users\/(\d+)\/tasks with:$/) do |method, uid, string|
  # @user_task_count variable is used in task_steps.rb and task_list_steps.rb
  path = "users/#{uid}/tasks"
  @user_task_count = User.find(uid).task_lists.first.tasks.count
  @request_time = Time.now.utc
  make_request(method, path, string)
end

When(/^the client submits a (.*) request to \/users(\/\S+)? with:$/) do |method, path, string|
  path = path == nil ? "/users" : "/users#{path}"
  @user_count = User.count 
  @user = (id = (/\d+/.match(path)).to_s) > '' ? User.find(id) : nil
  @request_time = Time.now.utc
  make_request(method, path, string)
end

When(/^the client submits a POST request to (.*) with the (\d+)(?:[a-z]{2}) user\'s credentials and:$/) do |path, id, string|
  @user = User.find(id)
  @user_task_count = @user.tasks.count
  authorize @user.username, @user.password
  make_request('POST', path, string)
end

When(/^the client submits a DELETE request to \/users\/(\d+) with the (\d+)(?:[a-z]{2}) user\'s credentials$/) do |path, id|
  user = User.find(id)
  authorize user.username, user.password
  make_request('DELETE', "/users/#{path}")
end

When(/^the client submits a DELETE request to the (first|last) task URL with the (\d+)(?:[a-z]{2}) user's credentials$/) do |order, id|
  user = User.find(id)
  @task = order == 'first' ? Task.first : Task.last
  @task_id = @task.id
  authorize user.username, user.password
  make_request('DELETE', "/tasks/#{@task.id}")
end

When(/^the client submits a DELETE request to the last task URL with no credentials$/) do 
  make_request('DELETE', "/tasks/#{Task.last.id}")
end

# RESPONSE STEPS
# ==============

Then(/^the JSON response should include all the (\d+)nd user's tasks$/) do |id|
  expect(response_body).to eql User.find(id).tasks.to_json
end

Then(/^the JSON response should include only the (in)?complete task(?:s)$/) do |scope|
  tasks = scope ? Task.incomplete : Task.complete
  response_body.should eql tasks.to_json
end

Then(/^the JSON response should (not )?include (?:only )?the (\d+)(?:[a-z]{2}) task$/) do |negation, id|
  if negation
    response_body.should_not include json_task(id)
  else 
    response_body.should === json_task(id)
  end
end

Then(/^the JSON response should include the (first|last) task$/) do |order|
  task = order == 'first' ? Task.first : Task.last
  expect(response_body).to eql task.to_json
end

Then(/^the response should not include any data$/) do 
  ok_values = [nil, '', 'null', false, 'Authorization Required']
  expect(ok_values).to include response_body
end

Then(/^the response should indicate the (?:.*) was (not )?saved successfully$/) do |negation|
  expect(response_status).to eql negation ? 422 : 201
end

Then(/^the response should indicate the (?:.*) was (not )?updated successfully$/) do |negation|
  expect(response_status).to eql negation ? 422 : 200
end

Then(/^the response should indicate the request was unauthorized$/) do
  expect(response_status).to eql 401
end

Then(/^the response should return status (\d{3})$/) do |status|
  expect(response_status).to eql status
end

Then(/^the response should indicate the (?:.*) was deleted successfully$/) do
  expect(response_status).to eql 204
end

Then(/^the response should indicate the (?:.*) was not found$/) do
  expect(response_status).to eql 404
end