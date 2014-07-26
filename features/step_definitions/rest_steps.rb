# REQUEST STEPS
# =============

When(/^the client submits a (.*) request to \/(\S+)$/) do |method, path|
  @request_time = Time.now
  make_request(method, path)
end

When(/^the client submits a (.*) request to \/tasks(\/(\S+))? with:$/) do |method, path, string|
  # @task_count variable is used in task_steps.rb and task_list_steps.rb
  path = path == nil ? "/tasks" : "/tasks#{path}"
  @task_count = Task.count
  @task = (id = (/\d+/.match(path)).to_s) > '' ? Task.find(id) : nil
  @request_time = Time.now
  make_request(method, path, string)
end

When(/^the client submits a (.*) request to \/users(\/\S+)? with:$/) do |method, path, string|
  path = path == nil ? "/users" : "/users#{path}"
  @user_count = User.count 
  @user = (id = (/\d+/.match(path)).to_s) > '' ? User.find(id) : nil
  @request_time = Time.now
  make_request(method, path, string)
end

# RESPONSE STEPS
# ==============

Then(/^the JSON response should include all the tasks$/) do 
  response_body.should === json_task(:all)
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

Then(/^the response should include an API key for the new user$/) do
  response_body.should === { 'secret_key' => User.last.secret_key }.to_json
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